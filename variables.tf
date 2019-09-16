variable "region" {
    default = "us-west1"
}

variable "instance-name" {
    default = "mc-server"
}

variable "network" {
    default = "minecraft"
}
variable "subnet" {
    default = "minecraft-1"
}

variable "credentials-file" {

}

variable "project" {

}

variable "machine-type" {
    default = "n1-standard-2"
}
variable "image" {
    default = "ubuntu-1604-xenial-v20190617"
}

variable "bootscript" {
    default = "./resources/dockerce-install.sh"
}
variable "ssh-user" {
    description = "Name of the user for SSH"
}
variable "ssh-public-key" {
    description = "Public key to give the instance"
}
variable "ssh-private-key" {
    description = "Private SSH key to login to the instance"
}


#server variables
variable "java" {
    default = "1"
}
variable "bedrock" {
    default = "0"
}

variable "gamemode" {
    description = "For a Java server: 0 for survival, 1 for creative. For Bedrock: survival or creative"
    default = "0"
}
variable "worldname" {
    description = "Name for the Minecraft world"
    default = "GKE"
}
variable "release" {
    description = "Version of minecraft to use"
    default = "1.12.2"
}
variable "server-type" {
    description = "This only supports VANILLA for now. Container also accepts FORGE, BUKKIT, SPIGOT, PAPER, CURSEFORGE, FTB, or SPONGEVANILLA"
    default = "VANILLA"
}

variable "ftb-modpack" {
    description = "Modpack download link if using FTB server type"
    default = "https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2690320"
}