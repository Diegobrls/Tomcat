
useradd -m -d /opt/tomcat -U -s /bin/false tomcat

apt update

apt install -y default-jdk

java -version

cd /tmp
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.20/bin/apache-tomcat-10.0.20.tar.gz
tar xzvf apache-tomcat-10*tar.gz -C /opt/tomcat --strip-components=1

chown -R tomcat:tomcat /opt/tomcat/
chmod -R u+x /opt/tomcat/bin

tee -a /opt/tomcat/conf/tomcat-users.xml <<END
<role rolename="manager-gui" />
<user username="manager" password="usuario" roles="manager-gui" />

<role rolename="admin-gui" />
<user username="admin" password="usuario" roles="manager-gui,admin-gui" />
END

sed -i '/<Valve/,/allow="127\\\.\\d\\+\\\.\\d\\+\\\.\\d\\+|::1|0:0:0:0:0:0:0:1"/ s/^/<!--/; /<Valve/,/allow="127\\\.\\d\\+\\\.\\d\\+\\\.\\d\\+|::1|0:0:0:0:0:0:0:1"/ s/$/-->/' /opt/tomcat/webapps/manager/META-INF/context.xml

sed -i '/<Valve/,/allow="127\\\.\\d\\+\\\.\\d\\+\\\.\\d\\+|::1|0:0:0:0:0:0:0:1"/ s/^/<!--/; /<Valve/,/allow="127\\\.\\d\\+\\\.\\d\\+\\\.\\d\\+|::1|0:0:0:0:0:0:0:1"/ s/$/-->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml

JAVA_PATH=$(update-java-alternatives -l | grep -oP '/usr/lib/jvm/java-\d+\.\d+\.\d+-openjdk-amd64')

tee /etc/systemd/system/tomcat.service <<END
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=$JAVA_PATH"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload

systemctl start tomcat

systemctl enable tomcat

ufw allow 8080

echo "Se admite el trafico a traves del puerto 8080."

# Accede a Tomcat a traves de esta URL
echo "Accede a la interfaz de Tomcat con esta URL: http://54.90.218.138:8080"
