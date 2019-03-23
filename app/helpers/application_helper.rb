module ApplicationHelper
    def flash_class(key)
        case key
        when 'alert'
            'is-warning'
        when 'notice'
            'is-info'
        when 'error'
            'is-danger'
        end
    end
end
