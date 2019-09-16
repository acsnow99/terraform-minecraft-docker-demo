sudo apt-get update -y
sudo apt-get install -y chrony dnsmasq dnsutils jq
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
# install docker compose
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.24.0/run.sh -o /usr/local/bin/docker-compose
# executable permissions for compose
sudo chmod +x /usr/local/bin/docker-compose

mkdir ~/minecraft

mv /tmp/server.properties ~/minecraft/server.properties

sudo docker pull itzg/minecraft-server
sudo docker run --name mc -e EULA=TRUE -e VERSION=1.14.4 -e TYPE=VANILLA -e FTB_SERVER_MOD=https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2690320 -v ~/minecraft:/data itzg/minecraft-server


