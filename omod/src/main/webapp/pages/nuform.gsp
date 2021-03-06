<%
    ui.decorateWith("appui", "standardEmrPage")

    ui.includeJavascript("nuform", "polyfills.bundle.js")
    ui.includeJavascript("nuform", "vendor.bundle.js")
    //Main has to be loaded after the other two
    //Otherwise it will lead to webpackJsonp is not defined
    ui.includeJavascript("nuform", "main.bundle.js")

    ui.includeJavascript("uicommons", "angular.js")
    ui.includeJavascript("uicommons", "ngDialog/ngDialog.js")
    ui.includeCss("uicommons", "ngDialog/ngDialog.min.css")

%>
<script type="text/javascript">
    var breadcrumbs = [
        {icon: "icon-home", link: '/' + OPENMRS_CONTEXT_PATH + '/index.htm'},
        {label: "${ ui.escapeJs(ui.message("nuform.nuformDrawboard.title")) }"}
    ]
</script>

<script>
    var formtype = "${formtype}";
    var imagePath;
    var height = 830;
    var width = 640;
    var backgroundImage = "${backgroundImage}";
    if (formtype === "${NUFORM_CONSTANTS.PERSONALFORM}") {
        imagePath = "../moduleServlet/dermimage/DermImageServlet?patId=${patientId}&image=${backgroundImage}"
    } else {
        imagePath = '../moduleServlet/nuform/NuformImageServlet?image=${backgroundImage}';
    }
    // If it is an online form, adjust to dimension.
    // 17-July-2016: The height and width are not currently supported in widget.
    if (backgroundImage.indexOf('://') > -1) {
        var img = new Image();
        img.onload = function () {
            height = img.height + 50;
            width = img.width;
        };
        imagePath = backgroundImage;
    }
    var NUFORM = {
        'image': imagePath,
        'width': width,
        'height': height,
        'nuform_in': '',
        'nuform_out': ''
    };
    // Ref Stackoverflow: 1224463
    var intervalID = setInterval(function () {

        if (NUFORM.nuform_out.length > 500) {
            jQuery('#saveMessase').empty();
            jQuery('#saveMessase').append('<h4>Saved! Submit to transfer this to database.</h4>' + 'Buffer: ' + NUFORM.nuform_out.length);

        } else {
            jQuery('#saveMessase').empty();
            jQuery('#saveMessase').append('<h4>Please save your work before submitting.</h4>' + 'Buffer: ' + NUFORM.nuform_out.length);
        }

    }, 5000);

    function saveNuform() {
        var imagemap = NUFORM.nuform_out;
        imagemap = imagemap.replace(/\"/g, '!');
        jQuery("#lesionmap").val(imagemap);
        if (imagemap.length < 3)
            return confirm("Form not saved. Submit empty form?");
        console.log(imagemap);
        return true;
    }

    jQuery(document).ready(function () {
        response = jQuery("#lesionmap").val();
        response = response.replace(/!/g, '"');
        NUFORM.nuform_in = response;
        console.log(response);
    });
</script>

<nuform-app>
    Loading...
</nuform-app>

<div id="saveMessase"></div>
<form onsubmit="return saveNuform()" method="post" action="${ui.pageLink("nuform", "nuform")}" name="FormName"
      id="FormName">

    <input name="lesionmap" id="lesionmap" type="hidden" value="${lesionmap}">
    <input name="nuformId" id="nuformId" type="hidden" value="${nuformId}">
    <input name="patientId" id="patientId" type="hidden" value="${patientId}">
    <input name="nuformDefId" id="nuformDefId" type="hidden" value="${nuformDefId}">

    <input value="Submit" name="SubmitButton" id="SubmitButton" type="submit">

</form>