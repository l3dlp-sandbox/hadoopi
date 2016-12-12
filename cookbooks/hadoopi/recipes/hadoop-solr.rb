
remote_file "/opt/solr-#{node['solr']['version']}.tgz" do
    source "http://archive.apache.org/dist/lucene/solr/#{node['solr']['version']}/solr-#{node['solr']['version']}.tgz"
    action :create_if_missing
end

execute "unpack solr" do
        command "tar -zxvf /opt/solr-#{node['solr']['version']}.tgz -C /opt/"
        user "root"
end

execute "create solr symlink" do
        command "if [ ! -d /opt/solr ]; then ln -s /opt/solr-#{node['solr']['version']} /opt/solr; fi"
        user "root"
end

execute "Chown solr" do
        command "chown hduser.hadoop -R /opt/solr"
        user "root"
end

execute "Chown solr-#{node['solr']['version']}" do
        command "chown -R hduser.hadoop /opt/solr-#{node['solr']['version']}"
        user "root"
end

# create solr hdfs folder
execute "start hdfs for solr" do
        command "/opt/hadoop/sbin/start-dfs.sh"
        user "hduser"
        returns [0,1]
end

execute "create solr folder" do
        command "/opt/hadoop/bin/hadoop fs -mkdir /solr"
        user "hduser"
        returns [0,1]
end

execute "chmod solr folder" do
        command "/opt/hadoop/bin/hadoop fs -chmod 777 /solr"
        user "hduser"
        returns [0,1]
end

execute "chmod tmp folder" do
        command "/opt/hadoop/bin/hadoop fs -chmod 777 /tmp"
        user "hduser"
        returns [0,1]
end

execute "stop hdfs" do
        command "/opt/hadoop/sbin/stop-dfs.sh"
        user "hduser"
end

