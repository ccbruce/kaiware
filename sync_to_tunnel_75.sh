#ssh -NfL *:7522:192.168.1.75:22    ccbruce@www.kingasiasys.com
rsync -avzh -e 'ssh -p 7522' *  ccbruce@localhost:/workspace/kaiware/
