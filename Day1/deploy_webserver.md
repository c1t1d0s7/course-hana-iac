# 웹 서버 배포

## 아파치 설치

```bash
sudo yum install -y httpd
```

```bash
ansible target -m yum -a 'name=httpd state=installed' -b
```

## 서비스 활성화/시작

```bash
sudo systemctl enable httpd
sudo systemctl start httpd
```

```bash
ansible target -m service -a 'name=httpd enabled=yes state=started' -b
```

## HTML 생성

```bash
sudo vi /var/www/html/index.html
```

```bash
ansible target -m copy -a 'content="hello" dest=/var/www/html/index.html' -b
```

## 방화벽 열기

```bash
sudo firewall-cmd --add-service http
sudo firewall-cmd --add-service http --permanenet
```

```bash
ansible target -m firewalld -a 'immediate=yes permanent=yes service=http state=enabled' -b
```
