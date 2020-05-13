https://releases.hashicorp.com/consul/1.7.3/consul_1.7.3_linux_amd64.zip


  - python-etcd python-consul psycopg2 psycopg2-binary setuptools


    1  dnf install patroni
    2  dnf install 
       epel-release
       python3
       gcc -y
       platform-python-devel
   
   
   25  pip3 install python-etcd
   26  pip3 install python-consul
   31  pip3 install patroni

   dnf install python3 gcc platform-python-devel python3-psycopg2 postgresql-server -y
   pip3 install python-consul patroni
