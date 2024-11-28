# 使い方

* wslとUbuntuは自分でインストールしましょう
* 以下のパッケージが必要なのでインストールします
  * ansible
  * git
  * openssh-server
  * 他にも(python3-yamlとかが)いるかもしれない…
* パスワードなしでsudoできる用にしましょう
  * `echo "$(whoami) ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/root`
* localhostにsshログインできるようにしましょう
  * sshのキーを作りましょう(ssh-keygen)
    * 既にある人は不要
  * ローカルにキーでsshできる様にしましょう
    * sshサーバが起動していないときは
      * `sudo systemctl enable ssh`
      * `sudo systemctl start ssh`
    * ローカルのauthorized_keysにキーを登録してしまいます
      * `ssh-copy-id localhost`
* リポジトリをcloneします
  * ansibleを実行します
    * `cd {リポジトリ}/ansible`
    * `ansible-playbook -i inventory/local playbook-wsl.yml`
* dotfilesにある設定を自分の設定に複製するなり設定を移植するなりしてリログインします

