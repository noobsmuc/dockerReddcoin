# Docker Reddcoin Image
This docker container implements a reddcoinClient to stake your Reddcoins.
Based an debian:jessie-20200607-slim

## Installation from Docker registry hub.
You can download the image with the following command:
```bash
docker pull noobsmuc/reddcoin
```

# How to use this image
## Exposed volume

 '/root/.reddcoin' used for the chain data, wallet and reddcoin.conf.    

### Hint:
In the volumn must be a 'reddcoin.conf' for the daemon to run.
"It is recommended you use the following random password:   
rpcuser=insert a username   
rpcpassword=insert a pwd   
(you do not need to remember this password)   
The username and password MUST NOT be the same."

# Build the image with specific reddcoin version
with the GIT_COMMIT_ID argument build the version you want. Default is 39088ca
see here https://github.com/reddcoin-project/reddcoin/releases

### Hint:
for the raspberry pi it's work with the 39088ca version not the with actuall f667036.   
We think it's related to the processor architecture issue https://github.com/m-pays/magi/issues/33

# Environment variables
This image uses environment variables to allow the configuration of some parameteres at run time:

### Variable name: PASSWORDPHRASE
Default value: ''   
Accepted values: your wallet passwodphrase (in plain text, sorry for that).

### Variable name: SLEEPNUMBERANDSUFFIX
Default value: '20m'   
Accepted values: allow values for linux sleep command.

# Container start
docker run -d --name reddcoin -e PASSWORDPHRASE="11 22 33 44 55 66 77 88 99 1010 1111 1212" -e SLEEPNUMBERANDSUFFIX="5m" -v E:/reddcoinChain:/root/.reddcoin noobsmuc/reddcoin

# Connet to container:
docker exec -it reddcoin /bin/bash 
