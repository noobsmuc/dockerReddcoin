##! /bin/bash

history -c

#exec >> /home/pi/logs/status.log 2>&1
#set -x

echo "run script"

export CPATH="/usr/local/BerkeleyDB.4.8/include"
export LIBRARY_PATH="/usr/local/BerkeleyDB.4.8/lib"
export LD_LIBRARY_PATH="/usr/local/BerkeleyDB.4.8/lib/"

reddCoinDaemonlogFile="/root/.reddcoin/debug.log"
logFile="/root/.reddcoin/check.log"
tmpFile="/root/.reddcoin/tmpReddcoinLog.tmp"

echo "$(date) reddcoinCheck start" > "$logFile"
echo "$(date) reddcoinCheck start" > "$reddCoinDaemonlogFile"

tail -f ${reddCoinDaemonlogFile} ${logFile} &

while true;
do
  echo "$(date) run loop" >> "$logFile"

  if grep -q  "Shutdown : done" ${reddCoinDaemonlogFile}; then
    echo "$(date) reddcoin shutdown done. break" >> "$logFile"
    echo "STOP" >> "$logFile"
    break
  fi

  case "$(pidof reddcoind | wc -w)" in
  0)  echo "$(date) reddcoin  wallet restarted" >> "$logFile"
      /usr/local/bin/reddcoind -daemon
      ;;

  1)  /usr/local/bin/reddcoin-cli getstakinginfo > "$tmpFile"
      if [ "`sed -ne 's/^.*staking[^:]*: \(.*\)$/\1/p' $tmpFile `" = "true," ]; then
        echo "$(date) reddcoin staking active"  >> "$logFile"
      else
        echo "$(date) reddcoin staking restart"  >> "$logFile"
        /usr/local/bin/reddcoin-cli walletpassphrase "${PASSWORDPHRASE}"  9999999 true
      fi
      ;;

   *) killall -9 reddcoind
      echo "kill all reddcoind" >> "$logFile"
      ;;

  esac

  sleep ${SLEEPNUMBERANDSUFFIX}
done

exit 0
