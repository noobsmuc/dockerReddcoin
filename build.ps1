# build with implicit GIT_COMMIT_ID -> means 39088ca
docker build -t noobsmuc/reddcoin:latest .

# build with explicit GIT_COMMIT_ID
#docker build -t  noobsmuc/reddcoin:latest --build-arg GIT_COMMIT_ID=f667036 .

