sudo apt-get
sudo apt-get update
sudo apt-get install awscli -y
sudo apt-get install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
sudo apt-get install mongo-tools -y
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
l -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt-get update
sudo apt-get install mongodb-database-tools -y
mongodump --version
aws configure
aws s3 ls --endpoint-url https://73207ffe52633eda4f9d15dd9f00753a.r2.cloudflarestorage.com
echo "Hello Cloudflare" > testfile.txt
aws s3 cp testfile.txt s3://mongodb-backup-bucket/ --endpoint-url https://73207ffe52633eda4f9d15dd9f00753a.r2.cloudflarestorage.com
nano backup_script.sh
chmod +x backup_script.sh
./backup_script.sh
crontab -e
pip3 install pymongo --break-system-packages
pip install pymongo --break-system-packages
sudo apt update && sudo apt install python3-pip -y
pip3 install pymongo --break-system-packages
nano seed_data.py
python3 seed_data.py
nano seed_data.py
sudo systemctl status mongod
sudo systemctl start mongod
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl status mongod
python3 seed_data.py
./backup_script.sh
tail -n 1 /home/ubuntu/backup_metrics.json
ls
nano backup_script,sh
ls
nano backup_script.sh
./backup_script.sh
tail -n 1 /home/ubuntu/backup_metrics.json
pip3 install streamlit pandas --break-system-packages
nano dashboard.py
streamlit run dashboard.py
python3 -m streamlit run dashboard.py
nano dashboard.py
python3 -m streamlit run dashboard.py
nohup python3 -m streamlit run dashboard.py > dashboard.log 2>&1 &
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
exit
