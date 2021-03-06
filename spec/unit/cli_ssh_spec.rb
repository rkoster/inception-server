# Copyright (c) 2012-2013 Stark & Wayne, LLC

# Specs for 'ssh' related behavior. Includes CLI commands:
# * ssh
# * tmux
# * mosh
describe Inception do
  include FileUtils
  include SettingsHelper

  before do
    setup_home_dir
    @cmd = Inception::Cli.new
    setting "provider.name", "aws"
    setting "provider.credentials.aws_access_key_id", "aws_access_key_id"
    setting "provider.credentials.aws_secret_access_key", "aws_secret_access_key"
    setting "provider.region", "us-west-2"
    setting "inception.key_pair.name", "inception"
    setting "inception.key_pair.private_key", "PRIVATE"
    setting "inception.provisioned.host", "5.5.5.5"
    setting "inception.provisioned.username", "vcap"
  end

  describe "ssh" do
    let(:private_key_path) { home_file(".inception_server/ssh/inception") }

    describe "normal" do
      it "launches ssh session" do
        @cmd.should_receive(:exit)
        @cmd.should_receive(:system).
          with("ssh -i #{private_key_path} vcap@5.5.5.5")
        @cmd.ssh
      end
      it "runs ssh command" do
        @cmd.should_receive(:exit)
        @cmd.should_receive(:system).
          with("ssh -i #{private_key_path} vcap@5.5.5.5 'some command'")
        @cmd.ssh("some command")
      end
    end

    describe "tmux" do
      it "launches ssh session" do
        @cmd.should_receive(:exit)
        @cmd.should_receive(:system).
          with("ssh -i #{private_key_path} vcap@5.5.5.5 -t 'tmux attach || tmux new-session'")
        @cmd.tmux
      end
    end

    describe "mosh" do
      before { Fog.mock! }
      after { Fog.unmock! }
      xit "should check whether mosh is installed" do
         @cmd.should_receive(:system).
          with("mosh --version")
        @cmd.stub!(:exit)
        @cmd.ensure_mosh_installed
      end
      xit "launches mosh session" do
        @cmd.stub!(:ensure_mosh_installed).and_return(true)
        @cmd.should_receive(:exit)
        @cmd.should_receive(:system).
          with("mosh --ssh 'ssh -i #{@private_key_path}' vcap@5.5.5.5")
        @cmd.mosh
      end
      xit "should ensure that the mosh ports are opened" do
        expected_ports = {
          mosh: { 
            protocol: "udp", 
            ports: (60000..60050) 
          }
        } 
        @cmd.provider.stub!(:create_security_group)
          .with('default','not used', expected_ports)
        @cmd.ensure_security_group_allows_mosh
      end
    end
  end
end
