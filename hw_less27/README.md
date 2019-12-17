### Домашнее задание  
установка почтового сервера  
1. Установить в виртуалке postfix+dovecot для приёма почты на виртуальный домен любым обсужденным на семинаре способом  
2. Отправить почту телнетом с хоста на виртуалку  
3. Принять почту на хост почтовым клиентом  

### Решение
 #### Описание  

 ВМ centos8 + postfix + dovecot  
 vup - поднимается ВМ и накатывается роль с обновлением системы, установкой постфикса + довекота + генерятся сертификаты(ca + server)  
 К IP 192.168.11.101 можно подключиться почтовым клиентом по IMAP  c использованием STARTTLS.  

У себя в /etc/hosts для тестов прописал:
192.168.11.101  mail0.lan

Ради интереса ещё прикрутил roundcube.
Разворачивается в плейбуке, зайти можно по http://192.168.11.101  
l:vagrant
p:vagrant

и , например, послать почту самому себе ))


отправка:  
openssl s_client -debug -starttls smtp -crlf -connect 192.168.11.101:587  
ehlo host  
mail from: test@tst.tst  
rcpt to: vagrant@mail0.lan
data
.


```shell
Return-Path: <test@test.tst>
X-Original-To: vagrant@mail0.lan
Delivered-To: vagrant@mail0.lan
Received: from host (unknown [192.168.11.1])
        by mail0.lan (Postfix) with ESMTPS id 70CAE477BE6
        for <vagrant@mail0.lan>; Mon, 16 Dec 2019 12:11:47 +0000 (UTC)
X-Evolution-Source: 190e4bd08fb656e7b85eef0420205bb795e390f9
```





Посьмо с заголовками(root-> vagrant):  
```shell
Return-Path: <root@mail0.lan>
X-Original-To: vagrant@mail0lan
Delivered-To: vagrant@mail0.lan
Received: by mail0.lan (Postfix, from userid 0)
        id A98D6109BBED; Fri, 13 Dec 2019 09:57:31 +0000 (UTC)
Date: Fri, 13 Dec 2019 09:57:31 +0000 (13.12.2019 12:57:31)
To: vagrant@mail0.lan
Subject: test
User-Agent: Heirloom mailx 12.5 7/5/10
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20191213095731.A98D6109BBED@mail0.lan>
From: root <root@mail0.lan>
X-Evolution-Source: 5f52006c008d0c878420e94e40f0517bd59d8ec9
```

**Конфиги:**
postfix:   
[main.cf](provisioning/roles/mailserver/files/main.cf)  
[master.cf](provisioning/roles/mailserver/files/master.cf)  
dovecot:    
[dovcot](provisioning/mailserver/files/../../roles/mailserver/files/dovecot/)    




