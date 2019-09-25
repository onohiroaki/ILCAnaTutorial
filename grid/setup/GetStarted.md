# GRID/DIRAC の設定方法

ILCDirac を使うには、
- KEK CA アカウント
- ILC VO への登録
- ILCDIRAC への登録
が必要


[https://twiki.cern.ch/twiki/bin/view/CLIC/IlcdiracRegistration](https://twiki.cern.ch/twiki/bin/view/CLIC/IlcdiracRegistration)
を参考にしてください。

## KEKCA のアカウント取得、Certificate 更新

### KEKCA アカウントの取得

参考資料
- KEK GRID CA Web Repository [https://gridca.kek.jp/](https://gridca.kek.jp/)
- KEK GRID CA Enrollment Manual [https://gridca.kek.jp/repository/usersmanual.html](https://gridca.kek.jp/repository/usersmanual.html)

アカウントの取得手続き
- [https://ccwww.kek.jp/ccsupport/ccapply/GRID/index.html](https://ccwww.kek.jp/ccsupport/ccapply/GRID/index.html)にある
[GRID CA システム申請書](https://ccwww.kek.jp/ccsupport/ccapply/GRID/20180628_GridCA-User_5.pdf)
をKEKCC 事務室に提出。
- インタービューを受け、問題なければアカウントが発行される。インタビューにあたっては、
[マニュアル](https://gridca.kek.jp/repository/usersmanual.html) に記載されている注意事項などをよく理解しておくこと。


### KEKCA アカウントの更新
毎年、KEKCAアカウントの更新が必要。更新は、
KEK GRID CA Web Enrollment Service [https://gridca.kek.jp/enroll.php](https://gridca.kek.jp/enroll.php)に
ログインして、revoke を行う。KEKCC アカウントのユーザー名とパスワードでログインする。
2. Revoke User Certificate より User certificate revocation のページに行き、 
revoke の理由としては、 unspecified を指定する。
Revoke したのちは、以下に述べる、userkey, usercert の更新などの処理も必要。



## KEKCC にて userkey, usercert を作成 
```

$ [ ! -e ~/.globus ] && mkdir ~/.globus
$ cd ~/.globus
$ /opt/kek/caclt/bin/certreq issue -uid ○○○○ -ucert
------------------------------------------- 
  creating a certificate signing request 
-------------------------------------------
generate private key (size 2048 bit)
...................................
.............
　　
please input your challenge pin or password to get a certificate.
Input Challenge PIN or Password : ■■■■■
　
(○○○○と■■■■■はKEKCA のユーザー名とパスワード）　
　　
○○○○ is now trying to login...14 bytes retrieved as CN
Input PASS Phrase: ●●●●●●
Verifying - Input PASS Phrase: ●●●●●●
save a private key file : userkey.pem
trying to connect RA server : rra01.kek.jp (11416) ... ok.
request for issuing a new certificate ... ok.
save a CA certificate file : 617ff41b.0
save a certificate file : usercert.pem
（●●●●●●はuserkey.pemのパスフレーズ。GRID認証に使用する)

$ chmod 400 userkey.pem
$ openssl pkcs12 -export -in usercert.pem -inkey userkey.pem -out mycert.p12
Enter pass phrase for userkey.pem: ●●●●●●
Enter Export Password: ▲▲▲▲▲▲▲▲
Verifying - Enter Export Password:▲▲▲▲▲▲▲▲
( ▲▲▲▲▲▲▲▲ は証明書を開封するためのパスワード。Web browserで使うとき使用する)

```


## Web browser に certificate の登録 (Windows10 の場合)

### Windows への登録
コントロールパネル⇒ネットワークとインターネット⇒インターネットオプション⇒コンテンツ　で証明書タブを開く
インポートで、mycert.p12 をインポートする。入力画面が現れたら、 

-　パスワード入力: ▲▲▲▲▲▲▲▲  
-　「秘密キーの保護を強力にする」「このキーをエクスポート可能にする」はチェックしない  
-　「すべての拡張プロパティーを含める」はチェック  
-　証明書ストアー：証明書をすべて次のストアに配置する、で「個人」を選ぶ  

コントロールパネルは、スタートボタンを左クリック⇒ Windowsシステムツール⇒コントロールパネル
で開くことができる。  
以上で、 Microsoft/Edge と Google Chrome で証明書を使えるようになる。

### Firefox
オプション⇒プライバシーとセキュリティー（左側のメニューより）⇒証明書　証明書を表示  
「あなたの証明書」に mycert.p12 をインポート


## ILC VO への登録
[https://grid-voms.desy.de:8443/voms/ilc](https://grid-voms.desy.de:8443/voms/ilc)より ILC VO 登録を申請する。

VOMS Admin for VO ilc <ilc-vo-support@desy.de> にもメールを出して、所属や身分、ILC VO の使用目的を説明し
承認するように依頼する。連絡が不十分だと、登録完了まで数日かかることがある。


## GRID-Certificate が有効になっていることを確認

```
$ source ./setup-cvmfs-ui.sh 
$ voms-proxy-init --voms ilc -valid 144:00 -vomslife 144:00
Enter GRID pass phrase for this identity:●●●●●●
Contacting grid-voms.desy.de:15110 [/C=DE/O=GermanGrid/OU=DESY/CN=host/grid-voms.desy.de] "ilc"...
Remote VOMS server contacted succesfully. 

Created proxy in /tmp/x509up_u111111. 

Your proxy is valid until Mon Dec 31 10:20:49 JST 2019 
$ voms-proxy-info -all
subject   : /C=JP/O=KEK/OU=CRC/CN=○○○○/CN=proxy
issuer    : /C=JP/O=KEK/OU=CRC/CN=○○○○
identity  : /C=JP/O=KEK/OU=CRC/CN=○○○○
type      : full legacy globus proxy
strength  : 1024
path      : /tmp/x509up_u11111
timeleft  : 143:59:49
key usage : Digital Signature, Non Repudiation, Key Encipherment, Data Encipherment
=== VO ilc extension information ===
VO        : ilc
subject   : /C=JP/O=KEK/OU=CRC/CN=○○○○
issuer    : /C=DE/O=GermanGrid/OU=DESY/CN=host/grid-voms.desy.de
attribute : /ilc/Role=NULL/Capability=NULL
timeleft  : 143:59:48
uri       : grid-voms.desy.de:15110 
```

## ILCDirac への登録

"Registration to iLCDirac is automatically done every day from the VOMS server."
なので1日待ては自動登録される模様。

## DIRAC Proxyの Upload 

```
$ source /cvmfs/clicdp.cern.ch/DIRAC/bashrc
$ dirac-proxy-init -UP -g ilc_user
Generating proxy...
Enter Certificate password:●●●●●●
Added VOMS attribute /ilc/Role=production
Uploading proxy for ilc_prod...
Uploading proxy for private_pilot...
Proxy generated:
subject      : /C=JP/O=KEK/OU=CRC/CN=○○○○/CN=999999/CN=111111
issuer       : /C=JP/O=KEK/OU=CRC/CN=○○○○/CN=999999
identity     : /C=JP/O=KEK/OU=CRC/CN=○○○○
timeleft     : 23:53:56
DIRAC group  : ilc_prod
rfc          : True
path         : /tmp/x509up_u111111
username     : ○○○○
properties   : NormalUser, ProductionManagement, JobSharing, JobAdministrator, StageAllowed
VOMS         : True
VOMS fqan    : ['/ilc/Role=production', '/ilc']

Proxies uploaded:
 DN                             | Group         | Until (GMT)
 /C=JP/O=KEK/OU=CRC/CN=○○○○ | private_pilot | 2019/12/31 01:09
 /C=JP/O=KEK/OU=CRC/CN=○○○○ | ilc_user      | 2019/12/31 01:09
```

## 以上で ILCDirac が使えるようになる。

ILCDirac 環境のセットアップは、
```
$ source /cvmfs/clicdp.cern.ch/DIRAC/bashrc
$ dirac-proxy-init -g ilc_user
```
