data "template_file" "bootscript" {
    template = "${file("${var.bootscript}")}"
    
    vars = {
        docker-image = "${lookup("${var.docker-image}", "${var.java}")}"
        #${lookup("${var.docker-image}", "${var.java}")}
        release = "${var.release}"
        server-type = "${var.server-type}"
        ftb-modpack = "${var.ftb-modpack}"
    }
}

data "template_file" "server-properties" {
    template = "${file("${lookup("${var.properties-file}", "${var.java}")}")}"
    
    vars = {
        worldname = "${var.worldname}"
        gamemode = "${var.gamemode}"
    }
}



resource "null_resource" "provision-files" {
    provisioner "local-exec" {
        command = "echo '${data.template_file.bootscript.rendered}' > ./resources/boot-script-provisioned.sh"
    }


    provisioner "local-exec" {
        command = "echo '${data.template_file.server-properties.rendered}' > ./resources/server.properties.provisioned"
    }
}



resource "null_resource" "add-world" {

    count = "${var.exists}"

    depends_on = [null_resource.provision-files]

    connection {
            type = "ssh"
            host = "${var.instance-ip}"
            user = "${var.ssh-user}"
            private_key = "${file("${var.ssh-private-key}")}"
    }

    provisioner "file" {
        source = "${var.existing-world}"
        destination = "/tmp/db"
    }

}

resource "null_resource" "bedrock-world-setup" {
    
    count = "${var.bedrock}"

    depends_on = ["null_resource.add-world", "null_resource.install-dependencies"]

    connection {
            type = "ssh"
            host = "${var.instance-ip}"
            user = "${var.ssh-user}"
            private_key = "${file("${var.ssh-private-key}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "rm -r ~/minecraft/worlds/${var.worldname}/db",
            "mkdir ~/minecraft/worlds/${var.worldname}/db",
            "cp -r /tmp/db/* ~/minecraft/worlds/${var.worldname}/db",
            "chmod -R 755 ~/minecraft/worlds/${var.worldname}/db",
            "sudo docker stop mc",
            "sudo docker start mc",
        ]
    }

}

resource "null_resource" "java-world-setup" {
    
    count = "${var.java}"

    depends_on = ["null_resource.add-world", "null_resource.install-dependencies"]
    
    connection {
            type = "ssh"
            host = "${var.instance-ip}"
            user = "${var.ssh-user}"
            private_key = "${file("${var.ssh-private-key}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "rm -r ~/minecraft/${var.worldname}",
            "mkdir ~/minecraft/${var.worldname}",
            "cp -r /tmp/db/* ~/minecraft/${var.worldname}",
            "chmod -R 755 ~/minecraft/${var.worldname}",
            "rm -r ~/minecraft/FeedTheBeast/${var.worldname}",
            "mkdir ~/minecraft/FeedTheBeast",
            "mkdir ~/minecraft/FeedTheBeast/${var.worldname}",
            "cp -r /tmp/db/* ~/minecraft/FeedTheBeast/${var.worldname}",
            "chmod -R 777 ~/minecraft/FeedTheBeast",
            "sudo docker stop mc",
            "sudo docker start mc",
        ]
    }

}



resource "null_resource" "install-dependencies" {

    depends_on = [null_resource.provision-files]

    connection {
            type = "ssh"
            host = "${var.instance-ip}"
            user = "${var.ssh-user}"
            private_key = "${file("${var.ssh-private-key}")}"
    }
    provisioner "file" {
        source = "./resources/boot-script-provisioned.sh"
        destination = "/tmp/run-command.sh"
    }
    provisioner "file" {
        source = "./resources/server.properties.provisioned"
        destination = "/tmp/server.properties"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo chmod 755 /tmp/run-command.sh",
            "/tmp/run-command.sh",
        ]
    }
}

resource "null_resource" "cleanup" {
    depends_on = [null_resource.install-dependencies]

    provisioner "local-exec" {
        command = "rm ./resources/server.properties.provisioned ./resources/boot-script-provisioned.sh"
    }
}