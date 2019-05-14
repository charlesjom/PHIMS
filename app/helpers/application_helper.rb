module ApplicationHelper
    def flash_class(key)
        case key
        when 'alert'
            'warning'
        when 'notice'
            'info'
        when 'error'
            'error'
        end
    end
end
