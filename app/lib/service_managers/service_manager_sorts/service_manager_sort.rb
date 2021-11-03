module ServiceManagerSort

  class SortDirection
    def is_satisfied_by?(resource)
        !resource.sort_option.to_s.empty?
    end
  end
end
