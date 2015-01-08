module AdvancedRoadmap
  module QueryPatch
    def self.included(base)
      base.class_eval do
  
        # Returns the milestones
        # Valid options are :conditions
        def milestones(options = {})
          Milestone.find(:all,
                         :include => :project,
                         :conditions => merge_conditions(project_statement, options[:conditions]))
        rescue ::ActiveRecord::StatementInvalid => e
          raise Query::StatementInvalid.new(e.message)
        end
  
      end
    end

	private
	
    def merge_conditions(*conditions)
		segments = []

		conditions.each do |condition|
		  unless condition.blank?
			sql = ActiveRecord::Base::sanitize(condition)
			segments << sql unless sql.blank?
		  end
		end

		"(#{segments.join(') AND (')})" unless segments.empty?
    end

  end
end
