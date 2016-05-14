# module ArangoDB
#   module OGM
#     module Queries
#
#     ##
#     # Result collection for executing AQL-based queries. Include ability to
#     # load the complete (batched) results.
#     class Result
#
#       attr_reader :query, :collection
#
#       def initialize(query)
#         @query = query
#       end
#
#       def execute
#
#         response = query.execute
#
#         if
#
#         @collection
#       end
#
#       def process_response(results)
#         results.body['hasMore']
#       end
#
#     end
#
#   end # OGM
# end # ArangoDB