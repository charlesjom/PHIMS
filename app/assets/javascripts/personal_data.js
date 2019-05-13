$(document).on ("turbolinks:load" ,function(){
    $('.tabular.menu .item').tab();

    $('.add-button.personal_data').each(function(index) {
        var $this = $(this);
        $this.off("click").on("click", function(e) {
            e.preventDefault();
            var divName = $this.data('collection')
            var attributeToAdd = $this.data('object')
            $.ajax('/personal_data/add_attribute', {
                "data": {
                    "attribute": attributeToAdd,
                    "collection": divName
                },
                "dataType": "script"
            });
        });
    });
});