require 'mastermind/dsl/compiler'

module Mastermind::DSL
  class InvalidArgument < StandardError; end
  class MissingKeyError < StandardError; end
end

# # # define name: "create and destroy an instance" do
# # #   create_ec2_server do
# # #     image_id '${image_id}'
# # #     flavor_id '${flavor_id}'
# # #     key_name '${key_name}'
# # #     region '${region}'
# # #     availability_zone '${availability_zone}'
# # #     groups '$f:groups'
# # #     tags '$f:tags'
# # #   end
# # # end
# # 
# # module Mastermind
# #   class DSL
# #     attr_accessor :participant, :params
# #     
# #     def initialize
# #       @name = nil
# #       @participant_class = nil
# #       @params = {}
# #     end
# #     
# #     def method_missing(symbol, *args, &block)
# #       if participant?(symbol)
# #         @name, @participant_class = get_participant(symbol)
# #         # this block is a participant
# #       end
# #       
# #       if args.size > 0 and args[0].is_a?(Hash)
# #         args[0].each do |key, value|
# #           @params[key] = value
# #         end
# #       end
# #       
# #       if block.nil?
# #         return
# #       else
# #         dsl = BlockDSL.new
# #         dsl.instance_eval block
# #       end
# #       
# #     end
# #     
# #     private
# #     
# #     def participant?(symbol)
# #       Mastermind.participants.each do |regexp, participant|
# #         return true if symbol =~ regexp
# #       end
# #       return false
# #     end
# #     
# #     def get_participant(symbol)
# #       Mastermind.participants.map do |key, participant|
# #         [ symbol, participant ] if symbol =~ key
# #       end.compact.first
# #     end
# #   end
# # end
# # 
# # d = Mastermind::DSL.new
# d.define :name => "foo" do
  # create_ec2_server do
  #   image_id '${image_id}'
  #   flavor_id '${flavor_id}'
  #   key_name '${key_name}'
  #   region '${region}'
  #   availability_zone '${availability_zone}'
  #   groups '$f:groups'
  #   tags '$f:tags'
  # end
# end
# 
# 
# module Mastermind
#   class DSL
#     
#     def initialize
#       @name = nil
#       @value = nil
#       @params = {}
#       @children = []
#     end
#     
#     def method_missing(sym, *args, &block)
#       @name = sym
#       
#       unless args.empty?
#         if args[0].is_a?(Hash)
#           args[0].each do |key, value|
#             @params[key] = value
#           end
#         else
#           @params[sym] = args[0]
#         end
#       end
#       
#       # block = args[-1] if block.nil? and !args.empty?
#       
#       if block.is_a? Proc
#         dsl = DSL.new
#         @children << dsl.instance_eval(&block)
#       end
#     end
#     
#     def self.instance
#       @@instance ||= new
#     end
#     
#   end # class DSL
# end # module Mastermind
# 
# def dsl
#   Mastermind::DSL.instance
# end