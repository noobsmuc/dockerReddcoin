# run on windows
docker run -d --name reddcoin -e PASSWORDPHRASE="11 22 33 44 55 66 77 88 99 1010 1111 1212" -e SLEEPNUMBERANDSUFFIX="20m" -v E:/reddcoinChain:/root/.reddcoin noobsmuc/reddcoin

# run on raspberry pi
#docker run -d --name reddcoin -e PASSWORDPHRASE="11 22 33 44 55 66 77 88 99 1010 1111 1212" -e SLEEPNUMBERANDSUFFIX="20m" -v /home/pi/reddcoinChain:/root/.reddcoin noobsmuc/reddcoin
