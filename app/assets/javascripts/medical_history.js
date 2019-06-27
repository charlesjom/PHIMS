$(document).on ("turbolinks:load" ,function(){
    $('.tabular.menu .item').tab();

    $('.add-button.medical_history').each(function(index) {
        var $this = $(this);
        $this.off("click").on("click", function(e) {
            e.preventDefault();
            var divName = $this.data('collection')
            var attributeToAdd = $this.data('object')
            $.ajax('/medical_histories/add_attribute', {
                "data": {
                    "attribute": attributeToAdd,
                    "collection": divName
                },
                "dataType": "script"
            });
        });
    });
});

