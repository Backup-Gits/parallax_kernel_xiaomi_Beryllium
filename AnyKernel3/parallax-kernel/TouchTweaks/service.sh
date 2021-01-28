
# Fingerprint boost

sleep 10
(
while true; do
echo $(pgrep fingerprintd) > /dev/cpuset/foreground/boost/tasks
renice -n -20 $(pgrep fingerprintd)
sleep 50
done
) &




