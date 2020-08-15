## ssl  
  
OpenSSL is a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS)  
  
requires:    
```
apt install openssl
```  
```
yum install openssl
```  
```
pacman -S openssl
```  
  
Automatic install/update:
```
sudo bash -c "$(curl -LSs https://github.com/casjay-dotfiles/ssl/raw/master/install.sh)"
```
Manual install:
```
sudo git clone https://github.com/casjay-dotfiles/ssl "/usr/local/etc/ssl"
ln -sf /usr/local/etc/ssl /stc/ssl/CA/CasjaysDev
```
  
  
<p align=center>
  <a href="https://wiki.archlinux.org/index.php/openssl" target="_blank">ssl wiki</a>  |  
  <a href="https://www.openssl.org/" target="_blank">ssl site</a>
</p>  
    
