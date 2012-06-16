module Fewbytes
  module ChefUtils
    class MMash < Mash
      def method_missing(m, *args)
        if has_key? m
          return self[m]
        else
          raise NoMethodError
        end
      end
    end

    class LightweightNode
      @@default_whitelist = {:fqdn => true, :hostname => true, :ipaddress => true, :roles => true, :recipes => true}

      def initialize(n, whitelist)
        @attrs = MMash.new
        @name = n.name
        @chef_environment = n.chef_environment
        @run_list = n.run_list

        if whitelist.is_a? Array
          whitelist = whitelist.inject(Hash.new) { |h, i| h[i] = true; h }
        end
        whitelist.merge(@@default_whitelist)
        @attrs = fetch_attrs(n, whitelist)
      end

      attr_reader :chef_environment
      attr_reader :name
      attr_reader :run_list

      def method_missing(m, *args)
        raise ArgumentError unless m.is_a? String or m.is_a? Symbol
        if @attrs.has_key? m
          return @attrs[m]
        else
          raise NoMethodError, "Can't find attribute matching #{m}"
        end
      end

      def has_key?(k)
        @attrs.has_key?(k)
      end

      alias :attribute? :has_key?

      def [](m)
        @attrs[m]
      end

      private
      def fetch_attrs(origin_hash, selection)
        return selection.inject(MMash.new()) do |h, item|
          if item.is_a? Array
            k, v = item
          else
            k, v = item, true
          end
          if v == true and origin_hash.has_key? k
            if origin_hash[k].is_a? ::Chef::Node::Attribute
              h[k] = origin_hash[k].to_hash
            else
              h[k] = origin_hash[k]
            end
          elsif v.is_a? Hash or v.is_a? MMash
            h[k] = fetch_attrs(origin_hash[k], v)
          end
          h
        end
      end

    end

    module LightweightSearch
      def lightweight_node_search(query, whitelist)
        nodes = []
        search(:node, query,'X_CHEF_id_CHEF_X asc', 0,  5) do |n|
          nodes << LightweightNode.new(n, whitelist)
        end
        return nodes
      end
    end
  end
end


class Chef::Recipe; include ::Fewbytes::ChefUtils::LightweightSearch ; end
