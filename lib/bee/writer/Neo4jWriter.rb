require 'neo4j-core'

module Bee
  class Neo4jWriter < Writer
    #if db_path is empty, we take server, otherwise embedded
    def initialize(db_path=".beedb",label="")
      if (db_path.empty?)
        @session = Neo4j::Session.open(:server_db)
        @embedded = false
      else
        @session = Neo4j::Session.open(:embedded_db, db_path)
        @session.start
        @embedded = true
      end

      @label = label
      @nodecache = Hash.new
    end

    def startup
      # NOP
    end

    def addNode(name)
      node = nil

      Neo4j::Transaction.run do
        node = Neo4j::Node.create({}, :node)
        yield node
      end

      @nodecache[name] = node.neo_id

      return node
    end

    def addEdge(et, from, to)
      edge = from.rels(dir: :outgoing, between: to)

      Neo4j::Transaction.run do
        if (edge and !edge.empty?)
          edge = edge.first
        else
          edge = Neo4j::Relationship.create(et, from, to)
        end

        yield edge
      end

      return edge
    end

    def addProperty(ele, key, val, label=false)
      ele[key] = val
    end

    def addLabel(ele, label)
      ele.add_label(label)
    end

    #label separating separate builds' databases inside server
    def addDatabaseLabel(ele)
      unless (@embedded or @label.empty?)
        ele.add_label(@label)
      end
    end

    def getProperty(ele, key)
      return ele[key]
    end

    def getNode(key, value, add=false)
      mynode = Neo4j::Node.load(@nodecache[value])
      if (!mynode) # Cache miss
        mynodes = Neo4j::Label.find_nodes(:node, key, value)
        if (mynodes.count == 1) # we found it!
          mynode = mynodes[0] 
        elsif (mynodes.count == 0) # Not in graph
          if (add) # Should we try to add the node?
            mynode = addNode(value) do |n|
              addProperty(n, key, value)
            end
          else
            #raise "ERROR: Node with property '#{key}' = '#{value}' not found"
            mynode = nil
          end
        elsif (mynodes.count > 1)
          raise "ERROR: Unexpected number of nodes #{mynodes.size} with property '#{key}' = '#{value}'"
        else
          raise "ERROR: Something very strange happened..."
        end
        if (mynode != nil)
          # actually add the node to the cache now
          @nodecache[value] = mynode.neo_id
        end
      end

      return mynode
    end

    def finished
      if (@embedded)
        @session.shutdown
      end
      
      @session.close
    end
  end
end
