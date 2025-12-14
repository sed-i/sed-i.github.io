# Privacy online

## Apps
- [Secure Messaging Apps Comparison](https://www.securemessagingapps.com/)


## Encrypted ClientHello (ECH)
Bare SNI is subject to eavesdropping/censorship.
[ECH](https://en.wikipedia.org/wiki/Server_Name_Indication#Encrypted_Client_Hello)
is encrypted SNI.

- Firefox `about:config` ([ref](https://blog.mozilla.org/security/2021/01/07/encrypted-client-hello-the-future-of-esni-in-firefox/)):
    - `network.dns.echconfig.enabled: true`
    - `network.dns.use_https_rr_as_altsvc: true`
