# Encoding: UTF-8

require_relative '../spec_helper.rb'
require_relative '../../libraries/helpers'

describe Maitred::Helpers do
  describe '.component_config_for' do
    let(:component) { nil }
    let(:config) { nil }
    let(:res) { described_class.component_config_for(component, config) }

    shared_context 'a nil config' do
      let(:config) { nil }

      it 'returns an empty string' do
        expect(res).to eq('')
      end
    end

    shared_context 'an empty config' do
      let(:config) { {} }

      it 'returns an empty string' do
        expect(res).to eq('')
      end
    end

    context 'an HA component' do
      let(:component) { :ha }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) do
          {
            provider: 'aws',
            aws_access_key_id: 'stuff',
            aws_secret_access_key: 'secretstuff',
            ebs_volume_id: 'vol-abc',
            ebs_device: '/dev/xvdf'
          }
        end

        it 'returns the expected output' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            ha['provider'] = 'aws'
            ha['aws_access_key_id'] = 'stuff'
            ha['aws_secret_access_key'] = 'secretstuff'
            ha['ebs_volume_id'] = 'vol-abc'
            ha['ebs_device'] = '/dev/xvdf'
          EOH
          expect(res).to eq(expected)
        end
      end
    end

    context 'an Nginx component' do
      let(:component) { :nginx }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) do
          {
            enable_non_ssl: true,
            ssl_ciphers: '!SSLv2:!SEED:!CAMELLIA:!PSK',
            ssl_protocols: 'TLSv1 TLSv1.1 TLSv1.2'
          }
        end

        it 'returns the expected output' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            nginx['enable_non_ssl'] = true
            nginx['ssl_ciphers'] = '!SSLv2:!SEED:!CAMELLIA:!PSK'
            nginx['ssl_protocols'] = 'TLSv1 TLSv1.1 TLSv1.2'
          EOH
          expect(res).to eq(expected)
        end
      end
    end

    context 'a Bookshelf component' do
      let(:component) { :bookshelf }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) { { vip: '1.2.3.4' } }

        it 'returns the expected output' do
          expect(res).to eq("bookshelf['vip'] = '1.2.3.4'")
        end
      end
    end

    context 'an LDAP component' do
      let(:component) { :ldap }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) do
          {
            host: 'ldap.example.com',
            port: 1234,
            ssl_enabled: true,
            bind_dn: 'cn=Private Chef,ou=IT,dc=example,dc=com',
            bind_password: "somethi'ngelse+3828'",
            base_dn: 'ou=Employees,dc=example,dc=com',
            login_attribute: 'uid',
            system_adjective: 'LDAP'
          }
        end

        it 'returns the expected output' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            ldap['host'] = 'ldap.example.com'
            ldap['port'] = 1234
            ldap['ssl_enabled'] = true
            ldap['bind_dn'] = 'cn=Private Chef,ou=IT,dc=example,dc=com'
            ldap['bind_password'] = 'somethi\\'ngelse+3828\\''
            ldap['base_dn'] = 'ou=Employees,dc=example,dc=com'
            ldap['login_attribute'] = 'uid'
            ldap['system_adjective'] = 'LDAP'
          EOH
          expect(res).to eq(expected)
        end
      end
    end

    context 'an Opscode Account component' do
      let(:component) { :account }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) { { worker_processes: 90 } }

        it 'returns the expected output' do
          expect(res).to eq("opscode_account['worker_processes'] = 90")
        end
      end
    end

    context 'an Opscode Erchef component' do
      let(:component) { :erchef }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) do
          {
            db_pool_size: 40,
            s3_url_ttl: 1200,
            strict_search_result_acls: true
          }
        end

        it 'returns the expected output' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            opscode_erchef['db_pool_size'] = 40
            opscode_erchef['s3_url_ttl'] = 1200
            opscode_erchef['strict_search_result_acls'] = true
          EOH
          expect(res).to eq(expected)
        end
      end
    end

    context 'an Opscode Expander component' do
      let(:component) { :expander }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) { { nodes: 9000 } }

        it 'returns the expected output' do
          expect(res).to eq("opscode_expander['nodes'] = 9000")
        end
      end
    end

    context 'an Opscode SOLR4 component' do
      let(:component) { :solr }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) { { heap_size: 342, max_field_length: 99 } }

        it 'returns the expected output' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            opscode_solr4['heap_size'] = 342
            opscode_solr4['max_field_length'] = 99
          EOH
          expect(res).to eq(expected)
        end
      end
    end

    context 'a PostgreSQL component' do
      let(:component) { :postgresql }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) { { max_connections: 3939 } }

        it 'returns the expected output' do
          expect(res).to eq("postgresql['max_connections'] = 3939")
        end
      end
    end

    context 'a RabbitMQ component' do
      let(:component) { :rabbitmq }

      include_context 'a nil config'
      include_context 'an empty config'

      context 'a populated config' do
        let(:config) { { node_ip_address: '1.2.3.4', vip: '5.6.7.8' } }

        it 'returns the expected output' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            rabbitmq['node_ip_address'] = '1.2.3.4'
            rabbitmq['vip'] = '5.6.7.8'
          EOH
          expect(res).to eq(expected)
        end
      end
    end

    context 'an unrecognized component' do
      let(:component) { :pantaloons }
      let(:config) { { test: 'test' } }

      it 'raises an error' do
        expect { res }.to raise_error(Maitred::Helpers::UnrecognizedComponent)
      end
    end
  end

  describe '.quote' do
    let(:item) { nil }
    let(:res) { described_class.quote(item) }

    context 'a true item' do
      let(:item) { true }

      it 'returns the item unquoted' do
        expect(res).to eq('true')
      end
    end

    context 'a false item' do
      let(:item) { false }

      it 'returns the item unquoted' do
        expect(res).to eq('false')
      end
    end

    context 'a string item' do
      let(:item) { 'thingsgohere' }

      it 'returns the item quoted' do
        expect(res).to eq("'thingsgohere'")
      end
    end

    context 'a string with single quotes in it' do
      let(:item) { "thing'here'" }

      it 'escapes the single quotes' do
        expect(res).to eq("'thing\\'here\\''")
      end
    end
  end
end
