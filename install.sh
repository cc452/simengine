#!/bin/bash

# Temporary install script.

update_fedora () {
	echo "-- Updating Fedora --"
	echo ""
	dnf -y update
	echo ""
}

replace_firewalld () {
	echo "-- Replacing Firewalld w/IPTables --"
	echo ""
	dnf -y install iptables-services
	systemctl stop firewalld
	systemctl enable iptables --now
	dnf -y remove firewalld
	iptables -F
	echo ""
}

firewall_rules () {
	echo "-- Applying Firewall Rules --"
	echo ""
	iptables -I INPUT 2 -p tcp --dport 8000 -m comment --comment "SimEngine WebSocket" -j ACCEPT
	iptables -I INPUT 2 -p udp --dport 8000 -m comment --comment "SimEngine WebSocket" -j ACCEPT
	iptables -I INPUT 2 -p tcp --dport 9000 -m comment --comment "SimEngine FrontEnd" -j ACCEPT
	iptables -I INPUT 2 -p udp --dport 9000 -m comment --comment "SimEngine FrontEnd" -j ACCEPT
	/sbin/service iptables save
	echo ""
}

install_utilities () {
	echo "-- Installing Common Utilities --"
	echo ""
	dnf -y install nmap vim
	echo ""
}

install_git () {
	echo "-- Installing git --"
	echo ""
	dnf -y install git
	echo ""
}

installl_nodejs () {
	echo "-- Installing NodeJS --"
	echo ""
	dnf -y install nodejs
	echo ""
}

set_hostname () {
	echo "-- Setting Hostname --"
	echo ""
	hostnamectl set-hostname --static simengine
	hostnamectl set-hostname --transient simengine
	echo ""
}

clone_repo () {
	echo "-- Cloning SimEngine Repo Into Home --"
	echo ""
#	git clone https://github.com/Seneca-CDOT/simengine.git
	mkdir -p /usr/share/simengine/
	chmod 755 -R /usr/share/simengine/
	git clone https://github.com/cc452/simengine.git /usr/share/simengine/
	echo ""
}

neo4j_repoadd () {
	echo "-- Adding Neo4j Repository --"
	echo ""
	rpm --import http://debian.neo4j.org/neotechnology.gpg.key
	echo "[neo4j]" > /etc/yum.repos.d/neo4j.repo
	echo "name=Neo4j RPM Repository" >> /etc/yum.repos.d/neo4j.repo
	echo "baseurl=http://yum.neo4j.org/stable" >> /etc/yum.repos.d/neo4j.repo
	echo "enabled=1" >> /etc/yum.repos.d/neo4j.repo
	echo "gpgcheck=1" >> /etc/yum.repos.d/neo4j.repo
	echo ""
}

database_install () {
	echo "-- Installing Databases --"
	echo ""
	dnf -y install redis neo4j python3-libvirt
	python3 -m pip install -r /usr/share/simengine/enginecore/requirements.txt
	pip install redis
	pip install snmpsim
	rm -rf /var/lib/neo4j/data/dbms/auth
	echo ""
}

start_db () {
	echo "-- Starting Database Daemons --"
	echo ""
	systemctl enable neo4j --now
	systemctl enable redis --now
	echo ""
}

create_dbuser () {
	echo "-- Creating SimEngine Database User --"
	echo ""
	sleep 4
	echo "CALL dbms.changePassword('neo4j-simengine'); CALL dbms.security.createUser('simengine', 'simengine', false);"|cypher-shell -u neo4j -p neo4j
	systemctl restart neo4j
	sleep 4
	echo ""
}

install_coredaemon () {
	echo "-- Installing and Starting SimEngine Core Daemon --"
	echo ""
	cp /usr/share/simengine/services/simengine-core.service /etc/systemd/system/simengine-core.service
	systemctl daemon-reload
	systemctl enable simengine-core --now
	echo ""
}

npm_installation () {
	echo "-- Running NPM Installation --"
	echo ""
	cd /usr/share/simengine/dashboard/frontend/
	npm install
	echo ""
}

npm_start () {
	echo "-- Starting NodeJS --"
	echo ""
	cd /usr/share/simengine/dashboard/frontend/
	npm start
	echo ""
}

update_fedora
replace_firewalld
install_utilities
install_git
installl_nodejs
set_hostname
clone_repo
neo4j_repoadd
database_install
start_db
create_dbuser
install_coredaemon
npm_installation
firewall_rules
npm_start
