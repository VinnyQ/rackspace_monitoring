require_relative 'spec_helper'

describe 'rackspace_monitoring_service_test::default on Ubuntu 14.04' do
  before do
    stub_resources
  end

  UBUNTU1404_SERVICE_OPTS = {
    log_level: LOG_LEVEL,
    platform: 'ubuntu',
    version: '14.04',
    step_into: 'rackspace_monitoring_service'
  }.freeze

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(UBUNTU1404_SERVICE_OPTS) do |node|
      node_resources(node)
    end.converge('rackspace_monitoring_service_test::default')
  end

  #
  # Resource in rackspace_monitoring_service_test::default
  #
  context 'rackspace_monitoring_service test recipe' do
    it_behaves_like 'rackspace monitoring agent set up', 'debian'
    context 'without cloud credential username' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1404_SERVICE_OPTS) do |node|
          node.set['rackspace_monitoring']['cloud_credentials_api_key'] = 'dummykey'
        end.converge('rackspace_monitoring_service_test::default')
      end
      it_behaves_like 'raise error about missing parameters'
    end
    context 'without cloud credential api_key' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1404_SERVICE_OPTS) do |node|
          node.set['rackspace_monitoring']['cloud_credentials_username'] = 'dummyusername'
        end.converge('rackspace_monitoring_service_test::default')
      end
      it_behaves_like 'raise error about missing parameters'
    end
    context 'without an entity' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(UBUNTU1204_SERVICE_OPTS) do |node|
          node_resources(node)
          node.set['rackspace_monitoring']['create_entity'] = false
        end.converge('rackspace_monitoring_service_test::default')
      end
      it_behaves_like 'agent set up without entity'
    end
  end
end
