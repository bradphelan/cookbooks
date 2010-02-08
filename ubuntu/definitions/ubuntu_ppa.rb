define :ubuntu_ppa, :listfile => nil, :url => nil, :key => nil, :branch => "main" do

  raise "Please set :listfile " unless params[:listfile]
  raise "Please set :url" unless params[:url]
  raise "Please set :key" unless params[:key]

  params[:codename] = `lsb_release -cs`.chomp
  params[:listfile] = "/etc/apt/sources.list.d/#{params[:listfile]}.list"

  execute "Add key #{params[:key]}" do
    command "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys #{params[:key]}"
  end

  template params[:listfile] do
    source "sources.list.d.erb"
    cookbook "ubuntu"

    variables \
      :url => params[:url],
      :code_name => params[:codename],
      :branch => params[:branch]
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end

end
