module Fewbytes::ChefUtils::LightWeightSearch
  def lightweight_node_search(query, whitelist))
    nodes = []
    search(:node, query,'X_CHEF_id_CHEF_X asc', 0,  5) do |n|
      nodes << ::Fewbytes::ChefUtils::LightweightNode.new(n, whitelist)
    end
    return nodes
  end
  
end

class Chef::Recipe; include Fewbytes::ChefUtils::LightWeightSearch ; end
