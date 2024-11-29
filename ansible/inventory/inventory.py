#!/usr/bin/env python3
# vim: set ts=4 sw=4 sts=0 fileencoding=utf-8 ff=unix :
import sys
import json
import yaml
import re
import os


def host_vars(host_name, host_json):
    host_var_json = {}
    # 実行時の環境変数の設定
    host_var_json['locale'] = json.loads('{}')
    host_var_json['locale']['LANG'] = 'C'
    host_var_json['locale']['LC_ALL'] = 'C'
    # 定義ファイルの設定を取得する
    for env_key in host_json.keys():
        host_var_json[env_key] = host_json[env_key]
    
    return host_var_json

def set_login_option(result_obj, host_obj):
    for i in host_obj:
        keys = [k for k, v in i.items()]
        for key in keys:
            result_obj[key] = i[key]
    return result_obj

def flat_data(result_obj, target_obj, host_name = None, env = None):
    # 情報はディクショナリでくるのでキーを取得する
    keys = [k for k, v in target_obj.items()]
    for key in keys:
        if key == 'env':
            result_obj = flat_data(result_obj, target_obj[key], host_name, env)
        elif key == 'group':
            for item in target_obj['group']:
                if isinstance(item, dict):
                    result_obj = flat_data(result_obj, item)
                else:
                    result_obj['group'].append(item)
        elif key == 'login-option':
            result_obj = set_login_option(result_obj, target_obj[key])
        else:
            result_obj[key] = target_obj[key]

    return result_obj

def create_inventory(hosts_obj, env, host_name = None):
    result_obj = {}
    meta = {}
    meta['hostvars'] = {}
    # Topレベルのキーを取得する
    top_fields = [k for k, v in hosts_obj.items()]
    # キーでループ
    for top_field in top_fields:
        # その項目に 'hosts' が存在するなら対象として処理する
        if isinstance(hosts_obj[top_field], dict) and 'hosts' in hosts_obj[top_field]:
            hostnames = [k for k, v in hosts_obj[top_field]['hosts'].items()]
            if host_name is not None:
                if host_name in hostnames:
                    host_obj = {}
                    host_obj['group'] = []
                    host_obj = flat_data(host_obj, hosts_obj[top_field]['hosts'][host_name], host_name, env)
                    if host_obj['environment_name'] != env:
                        # 環境違いは空を返却
                        return {}
                    host_obj['group'] = list(set(host_obj['group']))
                    return(host_vars(host_name, host_obj))
            else:
                for name in hostnames:
                    # ホスト1つづつ処理する為に初期化
                    host_obj = {}
                    host_obj['group'] = []
                    host_obj = flat_data(host_obj, hosts_obj[top_field]['hosts'][name], name, env)
                    if host_obj['environment_name'] != env:
                        # 環境違いはスキップ
                        continue
                    host_obj['group'] = list(set(host_obj['group']))
                    meta['hostvars'][name] = host_vars(name, host_obj)
                    # ホストの所属グループにホストを登録する
                    for group in host_obj['group']:
                        try:
                            result_obj[group]['hosts'].append(name)
                        except:
                            result_obj[group] = {}
                            result_obj[group]['hosts'] = [name]
    result_obj['_meta'] = meta
    return(result_obj)

def main():
    argv = sys.argv
    argc = len(argv)

    # 起動名称で処理を分岐するためのフラグ処理
    program_name = re.sub('.*/', '', argv[0])
    env = program_name.split('_')[0]

    hostlistfile = "inventory/hosts.yml"
    if (os.environ.get('ANSIBLE_HOST_LIST')):
        hostlistfile = os.environ.get('ANSIBLE_HOST_LIST')

    # ファイルから全ノードのリストを取得
    with open(hostlistfile) as hostlist:  # type: ignore
        hosts_obj = yaml.full_load(hostlist)
    
    if (argc >= 2 and argv[1] == '--host'):
        result_json = create_inventory(hosts_obj, env, argv[2])
    else:
        result_json = create_inventory(hosts_obj, env)

    print(json.dumps(result_json, sort_keys=False, indent=4))

if __name__ == "__main__":
    main()
