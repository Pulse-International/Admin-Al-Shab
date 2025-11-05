<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="ShabAdmin.Products" %>

<%@ Register Assembly="DevExpress.Web.v24.1, Version=24.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web" TagPrefix="dx" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <main>
        <style>
            .combo-large-font .dxeEditArea {
                font-size: 16px !important; /* You can increase or decrease as needed */
            }

            .error-popup-message {
                font-weight: bold;
                font-size: 18px;
                color: white;
                padding: 10px;
                text-align: center;
            }

            #popupValidationError_Content {
                background-color: #333;
            }

            #popupValidationError_Header {
                background-color: #444;
                color: white;
                font-family: 'Cairo', sans-serif;
                font-size: 18px;
            }


            .divSTARProviders {
                text-align: center;
                margin-left: auto;
                margin-right: auto;
            }

            .dxtcLite_Material.dxtc-top > .dxtc-stripContainer {
                display: inline-block;
            }

            .dxpc-mainDiv {
                font-family: 'Cairo', sans-serif;
            }

            .hintClass {
                background-color: #f7f7f7;
                color: #000000;
                font-family: cairo;
                border: 3px solid #c6bbff;
                border-radius: 1em;
            }

            .divSTARProviders {
                text-align: center;
                margin-left: auto;
                margin-right: auto;
            }

            .dxtcLite_Material.dxtc-top > .dxtc-stripContainer {
                display: inline-block;
            }
        </style>

        <script>
            var MyId;
            var MyIndex;
            var MyIndexDetail;
            var selectedCompanyId;
            var selectedCountryId;
            var checkBoxValue;
            var currentRowIndex = -1;


            function OnRowClick(e) {
                selectedCountryId = 0;
                selectedCompanyId = 0;
                l_CompanyID.SetText('0');
                l_CountryID.SetText('0');
                currentRowIndex = e.visibleIndex;
                SelectedBranchIds.SetText('0');
                MyIndex = e.visibleIndex;
                GridProducts.GetRowValues(MyIndex, 'id;countryID;companyID', OnGetRowValues);
            }

            function saveSelectedBranches() {
                var list = ASPxClientControl.Cast("listBoxBranches");
                var selected = list.GetSelectedValues();
                SelectedBranchIds.SetText(selected);
            }

            function OnGetRowValues(Value) {
                MyId = Value[0];
                selectedCompanyId = Value[2];
                selectedCountryId = Value[1];

                l_CompanyID.SetText(selectedCompanyId);
                l_Product_Id.SetText(MyId);
            }



            function OnGridBeginCallback(s, e) {
                if (e.command == 'STARTEDIT') {
                    window.uploadedImages = [];
                }
                if (e.command == 'ADDNEWROW') {
                    MyId = 0;

                    window.uploadedImages = [];
                }
                if (e.command == 'UPDATEEDIT') {
                }
                if (e.command == 'DELETEROW') {
                }
            }

            function onDeleteClick(visibleIndex, gridNo) {
                MyIndex = visibleIndex;

                Pop_Del_Grids.Show();
            }

            function updateGrid() {
                l_GridUpdating.SetText('1');
                setTimeout(function () {
                    GridProducts.StartEditRow(MyIndex);
                }, 100);
            }


            var isResetRequired = false;
            function onCountryChanged(s, e) {
                selectedCountryId = s.GetValue();
                SelectedBranchIds.SetText('');
                selectedCompanyId = 0;
                l_CountryID.SetText(selectedCountryId);
                l_GridUpdating.SetText('0');
                callback_LoadCompanies.PerformCallback(selectedCountryId + "|" + selectedCompanyId);
            }
            function onCityEndCallback(s, e) {
                if (isResetRequired) {
                    isResetRequired = false;
                    //s.SetSelectedIndex(0);
                }
            }

            function onCompanyChanged(s, e) {
                selectedCountryId = comboCountry.GetValue();
                selectedCompanyId = s.GetValue();
                l_CompanyID.SetText(selectedCompanyId);
                listBoxBranches.PerformCallback(MyId + "|" + selectedCountryId + "|" + selectedCompanyId);

                isResetRequired = true;
                setTimeout(function () {
                    var categoryEditor = GridProducts.GetEditor("categoryID");
                    categoryEditor.PerformCallback(selectedCountryId + "|" + selectedCompanyId);
                }, 300);
            }

            function checkOffer(s, e) {
                checkBoxValue = s.GetValue();
                GridProducts.GetRowValues(s.cp_index, 'id', CheckBoxOnGetRowValues);
            }

            function CheckBoxOnGetRowValues(Value) {
                setTimeout(function () {
                    callback_Offers.PerformCallback(Value + '|' + checkBoxValue);
                }, 500);
            }

            function OnRowClickDetail(e) {
                MyIndexDetail = e.visibleIndex;
            }

            function onDetailClick(id) {
                popDetails.Show();
            }

            var widthInPercent = 90;
            var heightInPercent = 80;
            function PopOnInit(s, e) {
                AdjustSize();
                ASPxClientUtils.AttachEventToElement(window, "resize", function (evt) {
                    AdjustSize();
                });
            }
            function AdjustSize() {
                var height = Math.max(0, document.documentElement.clientHeight);
                var width = Math.max(0, document.documentElement.clientWidth);
                if (width < 980)
                    widthInPercent = 90;
                else
                    widthInPercent = 55;
                popDetails.SetWidth(width * (widthInPercent / 100));
            }

            function OnImagePopupInit(s, e) {
                setTimeout(function () {

                    s.UpdatePosition();
                }, 300);
            }
            window.uploadedImages = [];

            function onMultiFileUploadComplete(s, e) {
                var url = e.callbackData;
                window.uploadedImages.push(url);
                renderPreview();
                toggleUploadControl();
            }

            function renderPreview() {
                var container = document.getElementById("previewImages");
                container.innerHTML = "";

                window.uploadedImages.forEach(function (url) {
                    var wrapper = document.createElement("div");
                    wrapper.style.cssText =
                        "position:relative;" +
                        "width:7em;" +
                        "border-radius:0.5rem;" +
                        "overflow:hidden;" +
                        "box-shadow:0 2px 6px rgba(0,0,0,0.1);" +
                        "transition:transform 0.2s ease,box-shadow 0.2s ease;";

                    // on hover: lift + show hint
                    wrapper.onmouseover = function () {
                        this.style.transform = 'translateY(-4px)';
                        this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
                        var h = this.querySelector('.hint');
                        h.style.opacity = '1';
                        h.style.transform = 'translateY(0)';
                    };
                    // on leave: reset + hide hint
                    wrapper.onmouseout = function () {
                        this.style.transform = 'translateY(0)';
                        this.style.boxShadow = '0 2px 6px rgba(0,0,0,0.1)';
                        var h = this.querySelector('.hint');
                        h.style.opacity = '0';
                        h.style.transform = 'translateY(100%)';
                    };

                    // thumbnail img
                    var img = document.createElement("img");
                    img.src = url + "?v=" + Date.now();
                    img.style.cssText = "display:block;width:100%;height:auto;cursor:pointer;";
                    img.onclick = function () { makeDefault2(url); };
                    wrapper.appendChild(img);

                    // hint overlay (initially hidden)
                    var hint = document.createElement("div");
                    hint.className = "hint";
                    hint.style.cssText =
                        "position:absolute;bottom:0;left:0;width:100%;" +
                        "background:rgba(0,0,0,0.7);color:#fff;font-size:0.85em;text-align:center;" +
                        "padding:0.25rem 0;opacity:0;transform:translateY(100%);" +
                        "transition:all 0.2s ease;pointer-events:none;";
                    hint.innerText = "اضغط لتعيين هذه الصورة الرئيسية";
                    wrapper.appendChild(hint);

                    // remove button...
                    var del = document.createElement("span");
                    del.innerHTML = "X";
                    del.style.cssText =
                        "position:absolute;top:0.25rem;right:0.25rem;" +
                        "width:1.5rem;height:1.5rem;line-height:1.5rem;" +
                        "background:rgba(0,0,0,0.5);color:#fff;font-size:1rem;" +
                        "text-align:center;border-radius:50%;cursor:pointer;" +
                        "transition:background 0.2s ease;";
                    del.onmouseover = () => del.style.background = 'rgba(255,0,0,0.8)';
                    del.onmouseout = () => del.style.background = 'rgba(0,0,0,0.5)';
                    del.onclick = () => removeImage(url);
                    wrapper.appendChild(del);

                    container.appendChild(wrapper);
                });

                toggleUploadControl();
            }

            function makeDefault2(path, id) {
                document.querySelectorAll('#previewImages .hint').forEach(h => {
                    h.style.opacity = '0';
                    h.style.transform = 'translateY(100%)';
                });

                l_DefaultImage.SetText(path);

                const clicked = Array.from(document.querySelectorAll('#previewImages img'))
                    .find(img => img.src.includes(path));
                if (clicked) {
                    const hint = clicked.parentNode.querySelector('.hint');
                    hint.style.opacity = '1';
                    hint.style.transform = 'translateY(0)';
                }

                var row = GridProducts.GetRow(currentRowIndex);
                if (row) {
                    var thumb = row.querySelector('.preview-container img');
                    if (thumb) {
                        thumb.src = path + '?v=' + new Date().getTime();
                    }
                }

            }


            function removeImage(url) {
                var pid = 0;
                if (typeof l_Product_Id !== "undefined" && l_Product_Id.GetText) {
                    pid = parseInt(l_Product_Id.GetText(), 10) || 0;
                }
                if (window.callbackRemoveImage) {
                    window.callbackRemoveImage.PerformCallback(url + "|" + pid);
                } else {
                    console.error("callbackRemoveImage is not initialized");
                }

                l_DefaultImage.SetText('');


                setTimeout(function () {
                    var total = getTotalImages();
                    var allowed = MAX_IMAGES - total;
                    AllowedImages.SetText(`إضافة صور جديدة (يمكن تحميل ${allowed} صور):`);
                }, 300)
                toggleUploadControl();
            }
            const MAX_IMAGES = 5;

            function getTotalImages() {
                const existingCount = document.querySelectorAll('#existingPreview > div').length;
                const newCount = window.uploadedImages ? window.uploadedImages.length : 0;

                return existingCount + newCount;
            }


            function toggleUploadControl() {
                const total = getTotalImages();

            }

            function onEditFormInit() {
                toggleUploadControl();
            }

            var currentProductId = null;

            function onImageClick() {
                const row = GridProducts.GetRow(currentRowIndex);
                if (!row) return;

                const thumb = row.querySelector('.preview-container img');
                if (!thumb) return;

                const src = thumb.src.toLowerCase();
                if (src.includes("nofile.png")) return;

                currentProductId = MyId;
                callbackImagePanel.PerformCallback(MyId);
            }





            function onFilesSelected(s, e) {
                e.cancel = true;

                const total = getTotalImages();
                const toSelect = s.GetText().split(',').filter(f => f.trim() !== '').length;
                const allowed = MAX_IMAGES - total;

                if (toSelect > allowed) {
                    popupLimitReached.SetHeaderText("تنبيه");
                    s.ClearText()
                    popupLimitReached.Show();
                    const fileInput = s.GetMainElement().querySelector('input[type="file"]');
                    setTimeout(() => {
                        if (typeof s.GetInputElement === 'function') {
                            s.GetInputElement().value = '';
                        }
                        else {
                            const fileInput = s.GetMainElement().querySelector('input[type="file"]');
                            if (fileInput) fileInput.value = '';
                        }
                    }, 0);


                    return;
                }
                AllowedImages.SetText(`إضافة صور جديدة (يمكن تحميل ${allowed} صور):`);
                popupMessage1.SetText(`لقد وصلت إلى الحد الأقصى لعدد الصور المسموح به.<br/>(يمكنك تحميل ${allowed} صور)`);

                s.Upload();
            }

            function makeDefault(imagePath) {
                callbackSetDefault.PerformCallback(currentProductId + "|" + imagePath);
            }



            function getCurrentImagePath() {
                let index = ImageSlider.GetActiveItemIndex();
                let item = ImageSlider.GetItem(index);
                if (!item) return null;

                let url = item.imageUrl;
                return url.split("?v=")[0];
            }

            function makeCurrentDefault() {
                const imgPath = getCurrentImagePath();
                if (!imgPath || !currentProductId) {
                    alert("حدث خطأ في تحديد الصورة.");
                    return;
                }

                callbackSetDefault.PerformCallback(currentProductId + "|" + imgPath);

                setTimeout(function () {
                    if (typeof GridProducts !== "undefined" && GridProducts.PerformCallback) {
                        GridProducts.PerformCallback();
                    }
                }, 500);
            }

            function renderMakeDefaultButtons() {
            }

            function makeDefault1(imagePath) {
                const pid = l_Product_Id.GetText();
                if (!pid || isNaN(pid)) {
                    alert("لم يتم تحديد المنتج.");
                    return;
                }
                l_DefaultImage.SetText('');
                callbackSetDefault.PerformCallback(pid + "|" + imagePath);
            }

            var lastGridCommand = null;

            function OnGridStartEditing(s, e) {

                lastGridCommand = e.command;

                if (e.command === 'STARTEDIT' || e.command === 'ADDNEWROW') {
                    const total = getTotalImages();
                    const allowed = MAX_IMAGES - total;

                    const rowElement = s.GetRow(currentRowIndex);

                    setTimeout(function () {


                        AllowedImages.SetText(`إضافة صور جديدة (يمكن تحميل ${allowed} صور):`);

                    }, 200);
                }
            }


            function onCategoryChanged(s, e) {
                var categoryId = s.GetValue();
                var subCombo = GridProducts.GetEditor("subCategoryId");
                if (subCombo) {
                    subCombo.PerformCallback(categoryId);
                }
            }

            function onSubCategoryCallback(s, e) {
                console.log("🔄 SubCategory loaded for categoryID: " + e.parameter);
            }

        </script>

        <div class="w-100 text-center my-4">
            <h2 class="pageTitle d-inline-block" style="font-family: Cairo">المنتجـــات</h2>
        </div>

        <div class="navbar-main navbar-expand-lg px-0 mx-4 border-radius-xl bg-white shadow mt-3 mb-1">

            <dx:ASPxGridView ID="GridProducts" runat="server" DataSourceID="db_Products" KeyFieldName="id" ClientInstanceName="GridProducts" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="0.81em" RightToLeft="True"
                OnCancelRowEditing="GridProducts_CancelRowEditing" OnRowValidating="GridProducts_RowValidating" OnRowInserting="GridProducts_RowInserting" OnRowUpdating="GridProducts_RowUpdating" OnRowUpdated="GridProducts_RowUpdated" OnRowDeleting="GridProducts_RowDeleting" OnHtmlRowCreated="GridProducts_HtmlRowCreated" OnRowInserted="GridProducts_RowInserted" OnCellEditorInitialize="GridProducts_CellEditorInitialize">
                <Settings ShowFooter="True" ShowFilterRow="True" />

                <ClientSideEvents BeginCallback="OnGridBeginCallback" ToolbarItemClick="function(s, e) {
                            selectedCountryId = 0;
                            selectedCompanyId = 0;
                            l_CompanyID.SetText('0');
                            l_CountryID.SetText('0');
                            SelectedBranchIds.SetText('0'); }"
                    RowClick="function(s,e){ OnRowClick(e); }"
                    RowDblClick="function(s,e){updateGrid(); }"
                    EndCallback=" function(s,e){ SelectedBranchIds.SetText(''); OnGridStartEditing(s, e);
                     if (s.cpShowUsedPopup === 'true') {
                         popupProductUsed.Show();
                         console.log('bukaayoooooooo saka ')
                         s.cpShowUsedPopup = null;
                     }}" />

                <SettingsAdaptivity AdaptivityMode="HideDataCells">
                </SettingsAdaptivity>
                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                <SettingsCommandButton>
                    <NewButton Text="جديد">
                    </NewButton>
                    <UpdateButton Text=" حفظ ">
                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                            <SpriteProperties Left="50px"></SpriteProperties>
                        </Image>
                    </UpdateButton>
                    <CancelButton Text=" الغاء ">
                        <Image Url="~/assets/img/cancel.png">
                        </Image>
                    </CancelButton>
                </SettingsCommandButton>

                <SettingsPopup>
                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                </SettingsPopup>

                <SettingsSearchPanel CustomEditorID="tbToolbarSearch1" />

                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                <Columns>

                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id" VisibleIndex="0" Width="1%">
                        <EditFormSettings Visible="False" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="الصور" VisibleIndex="1" FieldName="Images">
                        <EditFormSettings RowSpan="16" VisibleIndex="1" Caption=" "></EditFormSettings>

                        <DataItemTemplate>
                            <div class="preview-container" style="text-align: center; display: flex; justify-content: center;">

                                <img
                                    id="defaultThumbImg"
                                    src='<%# GetFirstImagePath(Eval("id")) %>?v=<%# DateTime.Now.Ticks %>'
                                    style="width: 7em; border: 1px solid #c8c8c8; border-radius: 5px; cursor: pointer;"
                                    onclick="setTimeout(function () {onImageClick()}, 300);" />
                            </div>
                        </DataItemTemplate>

                        <EditItemTemplate>
                            <div
                                style="font-family: 'Cairo', sans-serif; width: 100%; display: flex; flex-direction: column; align-items: center; gap: 1rem; padding: 1rem 0;">

                                <dx:ASPxLabel ID="AllowedImages" runat="server"
                                    ClientInstanceName="AllowedImages"
                                    Text="إضافة صور جديدة (يمكن تحميل 5 صور):"
                                    Font-Names="Cairo"
                                    Font-Size=" 1.1em" />
                                <div style="width: 80%;">
                                    <dx:ASPxUploadControl
                                        ID="multiImageUpload"
                                        runat="server"
                                        ClientInstanceName="multiImageUpload"
                                        EnableMultipleFileSelection="True"
                                        ShowProgressPanel="True"
                                        UploadMode="Advanced"
                                        AutoStartUpload="False"
                                        OnFileUploadComplete="MultiImageUpload_FileUploadComplete"
                                        ClientSideEvents-FileUploadComplete="onMultiFileUploadComplete"
                                        Style="width: 100%; border: 1px solid #ccc; border-radius: 4px; padding: 0.5rem; font-family: 'Cairo', sans-serif;">
                                        <AdvancedModeSettings EnableMultiSelect="true" />
                                        <ClientSideEvents TextChanged="onFilesSelected" />
                                        <ValidationSettings
                                            AllowedFileExtensions=".jpg,.jpeg,.png,.bmp"
                                            MaxFileSize="5248576" />
                                        <BrowseButton Text="اختيار صور..." />
                                    </dx:ASPxUploadControl>


                                </div>

                                <div
                                    id="previewImages"
                                    style="width: 80%; display: inline-grid; grid-template-columns: repeat(3,7em); grid-auto-rows: auto; grid-gap: 0.75rem; justify-content: center; margin-top: 0.5rem;">
                                </div>

                                <div style="width: 80%; text-align: right; margin-top: 1.5rem;">
                                    <span style="font-weight: bold; font-size: 1.1em;">الصور الحالية:</span>
                                </div>

                                <div
                                    id="existingPreview"
                                    style="width: 80%; display: inline-grid; grid-template-columns: repeat(3,7em); grid-auto-rows: auto; grid-gap: 0.75rem; justify-content: center; margin-top: 0.5rem;">
                                    <asp:Repeater
                                        ID="rptExistingImagesEdit"
                                        runat="server"
                                        DataSource='<%# GetImagesForProduct(Eval("id")) %>'>
                                        <ItemTemplate>
                                            <div
                                                style="font-family: 'Cairo', sans-serif; position: relative; width: 7em; border-radius: 0.5rem; overflow: hidden; box-shadow: 0 2px 6px rgba(0,0,0,0.1); transition: transform 0.2s ease, box-shadow 0.2s ease;"
                                                onmouseenter="this.style.transform='translateY(-4px)'; this.style.boxShadow='0 4px 12px rgba(0,0,0,0.15)'; var h=this.querySelector('.hint'); h.style.opacity='1'; h.style.transform='translateY(0)';"
                                                onmouseleave="this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 6px rgba(0,0,0,0.1)'; var h=this.querySelector('.hint'); h.style.opacity='0'; h.style.transform='translateY(100%)';">

                                                <img
                                                    src='<%# Eval("ImagePath") %>?v=<%# DateTime.Now.Ticks %>'
                                                    alt="Current Image"
                                                    style="display: block; width: 100%; height: auto; cursor: pointer;"
                                                    onclick="makeDefault1('<%# Eval("ImagePath") %>')" />

                                                <div
                                                    class="hint"
                                                    style="position: absolute; bottom: 0; left: 0; width: 100%; background: rgba(0,0,0,0.7); color: #fff; font-size: 0.85em; text-align: center; padding: 0.25rem 0; opacity: 0; transform: translateY(100%); transition: all 0.2s ease; pointer-events: none;">
                                                    اضغط لتعيين هذه الصورة الرئيسية
       
                                                </div>

                                                <span
                                                    style="position: absolute; top: 0.25rem; right: 0.25rem; width: 1.5rem; height: 1.5rem; background: rgba(0,0,0,0.5); color: #fff; font-size: 1rem; line-height: 1.5rem; text-align: center; border-radius: 50%; cursor: pointer; transition: background 0.2s ease;"
                                                    onmouseenter="this.style.background='rgba(255,0,0,0.8)';"
                                                    onmouseleave="this.style.background='rgba(0,0,0,0.5)';"
                                                    onclick="removeImage('<%# Eval("ImagePath") %>')"
                                                    title="حذف الصورة">X</span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </div>


                                <dx:ASPxCallback
                                    ID="callbackRemoveImage"
                                    runat="server"
                                    ClientInstanceName="callbackRemoveImage"
                                    OnCallback="callbackRemoveImage_Callback"
                                    Style="display: none;">
                                    <ClientSideEvents
                                        Init="function(s,e){ window.callbackRemoveImage = s; }"
                                        CallbackComplete="function(s,e){
                                              var newPath = s.cp_newDefault;
                                              var url = s.cp_deletedUrl;
                                              var idx = window.uploadedImages.indexOf(url);
                                              if(idx &gt; -1){ window.uploadedImages.splice(idx,1); renderPreview(); }
                                              document.querySelectorAll('#existingPreview img').forEach(function(img){
                                                if(img.src.indexOf(url) !== -1) img.parentNode.remove();
                                              });
                                              // 3) patch the one thumbnail in the grid row
                                              var row = GridProducts.GetRow(currentRowIndex);
                                              if(row) {
                                                var thumb = row.querySelector('.preview-container img');
                                                if(thumb) {
                                                  thumb.src = newPath + '?v=' + new Date().getTime();
                                                }
                                              }
                                            }" />

                                </dx:ASPxCallback>
                            </div>
                        </EditItemTemplate>

                    </dx:GridViewDataColumn>



                    <dx:GridViewDataColumn Caption="الاسم" FieldName="name" VisibleIndex="2" Width="10%">
                        <EditItemTemplate>
                            <div class="row">
                                <div style="width: 100%" id="textfield">
                                    <dx:ASPxComboBox ID="comboName" Font-Names="cairo" runat="server" OnInit="comboName_Init"
                                        Value='<%# Bind("name") %>' Width="100%"
                                        DropDownStyle="DropDownList"
                                        DataSourceID="dsProducts"
                                        TextField="Name"
                                        ValueField="UID"
                                        ClientInstanceName="comboName">
                                    </dx:ASPxComboBox>

                                    <dx:ASPxTextBox ID="txtName" Font-Names="cairo" runat="server" OnInit="txtName_Init"
                                        Text='<%# Bind("name") %>' Width="100%" ClientInstanceName="txtName" />
                                </div>
                                <div style="width: 100%">
                                    <dx:ASPxCheckBox ID="chkUseText" runat="server" Font-Names="cairo" Width="100%" OnInit="chkUseText_Init"
                                        Text="اختر هذا الخيار في حال اسم المنتج غير موجود ليتم تعبئته يدويا" ClientInstanceName="chkUseText">
                                        <ClientSideEvents CheckedChanged="function(s, e) {
                                                var isChecked = s.GetChecked();
                                                comboName.SetVisible(!isChecked);
                                                txtName.SetVisible(isChecked);

                                                // Save state for server-side logic
                                                comboNameValue.SetText(s.GetValue()); // save selected UID
                                                comboNameText.SetText(s.GetValue()); // save selected UID
                                                chkUseTextState.SetText(isChecked ? '1' : '0');
                                            }" />
                                    </dx:ASPxCheckBox>
                                </div>
                            </div>
                        </EditItemTemplate>
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataTextColumn Caption="الاسم بالانجليزي" FieldName="nameEn" VisibleIndex="3">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataTextColumn>


                    <dx:GridViewDataTextColumn Caption="الوصف" FieldName="description" VisibleIndex="3">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataTextColumn>


                    <dx:GridViewDataSpinEditColumn Caption="باركود" FieldName="barcode" Name="barcodeColumn" VisibleIndex="4">
                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="14" NullDisplayText="00000000000000">
                            <ValidationSettings Display="Dynamic" SetFocusOnError="True">
                                <RequiredField ErrorText="الرجاء إدخال الباركود" IsRequired="True" />
                            </ValidationSettings>
                        </PropertiesSpinEdit>
                        <EditFormSettings Visible="True" />
                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataSpinEditColumn Caption="السعر" FieldName="price" VisibleIndex="5">
                        <DataItemTemplate>
                            <%# Eval("price") + "</br>" + MainHelper.GetCurrency(Eval("countryId")) %>
                        </DataItemTemplate>
                        <EditFormSettings Visible="True" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataSpinEditColumn>

                    <dx:GridViewDataTextColumn Caption="بنكهات" FieldName="isHasFlavors" VisibleIndex="6">
                        <PropertiesTextEdit>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="Country name in arabic is required." Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                        </PropertiesTextEdit>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                        </CellStyle>
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataComboBoxColumn Caption="مرئي" FieldName="isVisible" VisibleIndex="7">
                        <PropertiesComboBox ValueType="System.String" DropDownStyle="DropDownList">
                            <Items>
                                <dx:ListEditItem Text="نعم" Value="True" />
                                <dx:ListEditItem Text="لا" Value="False" />
                            </Items>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="الرجاء الاختيار" Display="Dynamic">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                            <ItemStyle Font-Size="X-Large" />

                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        <EditFormSettings Visible="True" />
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataComboBoxColumn Caption="سعر ام زيادة" FieldName="isProductPrice" VisibleIndex="7">
                        <PropertiesComboBox ValueType="System.String" DropDownStyle="DropDownList">
                            <Items>
                                <dx:ListEditItem Text="سعر" Value="True" />
                                <dx:ListEditItem Text="زيادة" Value="False" />
                            </Items>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="الرجاء الاختيار" Display="Dynamic">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                            <ItemStyle Font-Size="X-Large" />

                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        <EditFormSettings Visible="True" />
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataComboBoxColumn Caption="مميز" FieldName="isSpecial" VisibleIndex="7">
                        <PropertiesComboBox ValueType="System.String" DropDownStyle="DropDownList">
                            <Items>
                                <dx:ListEditItem Text="نعم" Value="True" />
                                <dx:ListEditItem Text="لا" Value="False" />
                            </Items>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="الرجاء الاختيار" Display="Dynamic">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                            <ItemStyle Font-Size="X-Large" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        <EditFormSettings Visible="True" />
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataComboBoxColumn Caption="وزن أو كمية" FieldName="isWeight" VisibleIndex="7">
                        <PropertiesComboBox ValueType="System.String" DropDownStyle="DropDownList">
                            <Items>
                                <dx:ListEditItem Text="وزن" Value="True" />
                                <dx:ListEditItem Text="كمية" Value="False" />
                            </Items>
                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="الرجاء الاختيار" Display="Dynamic">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                            <ItemStyle Font-Size="X-Large" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                        <EditFormSettings Visible="True" />
                    </dx:GridViewDataComboBoxColumn>


                    <dx:GridViewDataComboBoxColumn Caption="البلد" FieldName="countryID" VisibleIndex="8">
                        <PropertiesComboBox
                            ClientInstanceName="comboCountry"
                            DataSourceID="dsCountries"
                            TextField="countryName"
                            ValueField="id"
                            DropDownStyle="DropDownList"
                            EnableCallbackMode="false">
                            <ClientSideEvents SelectedIndexChanged="onCountryChanged" />
                            <ValidationSettings
                                RequiredField-IsRequired="true"
                                SetFocusOnError="True"
                                ErrorText="الرجاء اختيار البلد"
                                Display="Dynamic">
                                <RequiredField IsRequired="True" />
                            </ValidationSettings>
                            <ItemStyle Font-Size="X-Large" />
                        </PropertiesComboBox>
                        <EditFormSettings Visible="True" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataComboBoxColumn>


                    <dx:GridViewDataColumn Caption="الشركة" FieldName="companyID" VisibleIndex="9" Width="7%" Visible="false">
                        <DataItemTemplate>
                            <%# Eval("companyName") %>
                        </DataItemTemplate>
                        <EditItemTemplate>
                            <dx:ASPxCallbackPanel ID="callback_LoadCompanies" runat="server"
                                ClientInstanceName="callback_LoadCompanies"
                                OnCallback="callback_LoadCompanies_Callback">
                                <ClientSideEvents Init=" function(s, e) {
                                                setTimeout(function () {                                                    
                                                    callback_LoadCompanies.PerformCallback(selectedCountryId + '|' + selectedCompanyId);                                                                                                 
                                                }, 100);
                                        } "
                                    EndCallback="function(s, e) {                                        
                                            listBoxBranches.PerformCallback(MyId + '|' + selectedCountryId + '|' + selectedCompanyId);                                            
                                            }" />
                                <PanelCollection>
                                    <dx:PanelContent>
                                        <dx:ASPxComboBox ID="comboCompany" runat="server" Font-Names="cairo"
                                            ClientInstanceName="comboCompany"
                                            ValueField="id"
                                            TextField="companyName"
                                            ValueType="System.Int32"
                                            DropDownStyle="DropDownList"
                                            Width="100%">
                                            <ItemStyle Font-Size="X-Large" />

                                            <ClientSideEvents Init="function(s, e) { 
                                                        
                                                    }"
                                                SelectedIndexChanged="onCompanyChanged" />

                                        </dx:ASPxComboBox>
                                    </dx:PanelContent>
                                </PanelCollection>

                            </dx:ASPxCallbackPanel>
                        </EditItemTemplate>
                        <EditFormSettings Visible="True" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataComboBoxColumn Caption="الشركــة" FieldName="companyID" Width="10%" VisibleIndex="10">
                        <EditFormSettings Visible="False" />
                        <PropertiesComboBox DataSourceID="db_Company" TextField="companyName" ValueField="id" ValueType="System.Int32" EncodeHtml="False">
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle">
                        </CellStyle>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataComboBoxColumn Caption="المجموعة" FieldName="categoryID" VisibleIndex="11">
                        <PropertiesComboBox ClientInstanceName="cmbCategory"
                            DataSourceID="db_Categories"
                            TextField="name"
                            ValueField="id"
                            ValueType="System.Int32"
                            EnableCallbackMode="false">
                            <ClientSideEvents SelectedIndexChanged="onCategoryChanged" EndCallback="onCityEndCallback" />
                            <ValidationSettings RequiredField-IsRequired="true" ErrorText="اختر المجموعة" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                            <ItemStyle Font-Size="X-Large" />
                        </PropertiesComboBox>
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataComboBoxColumn>


                    <dx:GridViewDataComboBoxColumn Caption="المجموعة الفرعية" FieldName="subCategoryId" VisibleIndex="12">
                        <DataItemTemplate>
                            <%# Eval("subName") %>
                        </DataItemTemplate>
                        <PropertiesComboBox
                            DataSourceID="db_SubCategories"
                            TextField="subName"
                            ValueField="id"
                            ValueType="System.Int32"
                            ClientInstanceName="cmbSubCategory"
                            EnableCallbackMode="true">
                            <ValidationSettings RequiredField-IsRequired="true" ErrorText="اختر المجموعة" Display="Dynamic">
                                <RequiredField IsRequired="True"></RequiredField>
                            </ValidationSettings>
                            <ItemStyle Font-Size="X-Large" />
                            <ClientSideEvents EndCallback="onCityEndCallback" />
                        </PropertiesComboBox>
                        <EditFormSettings Visible="true" VisibleIndex="12" />
                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center" />
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataColumn Caption="الفروع" Width="10%" VisibleIndex="13">
                        <DataItemTemplate>

                            <div style="height: 7em; overflow-y: auto; scrollbar-color: #000000 #a88fff;">

                                <dx:ASPxLabel
                                    ID="BranchNames"
                                    runat="server"
                                    Font-Names="Cairo"
                                    Font-Size="X-Small"
                                    EncodeHtml="false" />

                            </div>
                        </DataItemTemplate>


                        <EditItemTemplate>
                            <dx:ASPxListBox
                                ID="listBoxBranches"
                                runat="server"
                                ClientInstanceName="listBoxBranches"
                                EnableCallbackMode="true"
                                OnCallback="listBoxBranches_Callback"
                                TextField="groupName"
                                ValueField="branchID"
                                Width="100%"
                                ValueType="System.String"
                                SelectionMode="CheckColumn"
                                Font-Names="Cairo"
                                EnableMultiSelection="True"
                                Height="200px"
                                EnableSelectAll="True">
                                <ClientSideEvents
                                    SelectedIndexChanged="function(s,e){
                                          SelectedBranchIds.SetText(s.GetSelectedValues().join(','));
                                        }"
                                    EndCallback="function(s, e) { SelectedBranchIds.SetText(s.GetSelectedValues().join(',')); }" />

                            </dx:ASPxListBox>
                        </EditItemTemplate>

                        <EditFormSettings Visible="True" />
                        <CellStyle VerticalAlign="Middle" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataColumn Caption="" VisibleIndex="14">
                        <EditFormSettings Visible="False" />
                        <DataItemTemplate>
                            <img src="/assets/img/details.png" width="32" height="32" title="الخيارات والإضافات" style="cursor: pointer" onclick="onDetailClick(<%# Eval("id") %>);" />
                        </DataItemTemplate>
                        <CellStyle VerticalAlign="Middle" />
                    </dx:GridViewDataColumn>

                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="8%" VisibleIndex="15">
                        <EditFormSettings Visible="False" />
                        <DataItemTemplate>
                            <div style="width: 100%; float: left; text-align: center">
                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="updateGrid();" />
                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="onDeleteClick(<%# Container.VisibleIndex %>,'1');" />
                            </div>
                        </DataItemTemplate>
                    </dx:GridViewDataTextColumn>



                </Columns>

                <Toolbars>
                    <dx:GridViewToolbar ItemAlign="left">
                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                        <Items>
                            <dx:GridViewToolbarItem Command="New" Text="جديد" />
                            <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Text="تحديث الجدول" />
                            <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                            <dx:GridViewToolbarItem Command="ExportToPdf" />

                            <dx:GridViewToolbarItem Alignment="Right" Name="toolbarItemSearch" BeginGroup="true" AdaptivePriority="2">
                                <Template>
                                    <dx:ASPxButtonEdit ID="tbToolbarSearch1" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                </Template>
                            </dx:GridViewToolbarItem>

                        </Items>
                    </dx:GridViewToolbar>
                </Toolbars>
                <TotalSummary>
                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                </TotalSummary>
                <Styles>
                    <AlternatingRow BackColor="#F0F0F0">
                    </AlternatingRow>
                    <Footer Font-Names="cairo">
                    </Footer>
                    <EditFormTable Font-Size="1.7em">
                    </EditFormTable>
                </Styles>
                <Paddings Padding="2em" />
            </dx:ASPxGridView>

            <asp:SqlDataSource
                ID="dsCountries"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id, countryName FROM countries where id in (select countryId from companies) AND id <> 1000"></asp:SqlDataSource>

            <asp:SqlDataSource ID="dsProducts" runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT DISTINCT UID, Name FROM products ORDER BY Name"></asp:SqlDataSource>

            <asp:SqlDataSource ID="db_Categories" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id,name FROM categories "></asp:SqlDataSource>

            <asp:SqlDataSource ID="db_Categories_Selected" runat="server" ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id,name FROM categories where countryId=@countryId AND companyId=@companyId">
                <SelectParameters>
                    <asp:Parameter Name="countryId" />
                    <asp:Parameter Name="companyId" />
                </SelectParameters>
            </asp:SqlDataSource>


            <asp:SqlDataSource
                ID="db_SubCategories"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT id, subName FROM categoriesSub WHERE (categoryId = @categoryId OR @categoryId =0)">
                <SelectParameters>
                    <asp:Parameter Name="categoryId" Type="Int32" DefaultValue="0" />
                </SelectParameters>
            </asp:SqlDataSource>


            <asp:SqlDataSource
                ID="db_Company"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT p.id, p.companyName + ' <br> (' + (select c.countryName from countries c where c.id = p.countryId) + ')' as companyName FROM companies p where p.id <> 1000"></asp:SqlDataSource>

            <asp:SqlDataSource
                ID="DB_BranchNames"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT b.name AS BranchName
                                   FROM branchproducts bp
                                   INNER JOIN branches b ON bp.branchId = b.id
                                   WHERE bp.productId = @productID">
                <SelectParameters>
                    <asp:Parameter Name="productID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>


            <asp:SqlDataSource
                ID="dsBranches"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="SELECT b.id AS branchID, b.name AS groupName FROM branches b" />


            <asp:SqlDataSource
                ID="db_Products"
                runat="server"
                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                SelectCommand="
                    SELECT 
                    p.[id], 
                    p.[name], 
                    p.[description], 
                    p.[categoryID], 
                    p.[subCategoryId], 
                    cs.[subName],           
                    p.[price], 
                    p.[isVisible], 
                    p.[isWeight], 
                    p.[isProductPrice], 
                    p.[barcode], 
                    p.[nameEn], 
                    p.[countryID], 
                    p.[companyID], 
                    c.[companyName],       
                    p.[isHasFlavors],
                    p.[isSpecial]
                FROM [products] p
                LEFT JOIN [companies] c ON p.companyID = c.id
                LEFT JOIN [categoriesSub] cs ON p.subCategoryId = cs.id  
                Where p.isvirtual = 0
                ORDER BY p.id ASC;"
                InsertCommand="
                INSERT INTO [products]
                    ([name],[description],  [categoryID], [subCategoryId], [price], [nameEn], [countryID],  [companyID], [isHasFlavors], [isSpecial], [isVisible],[isProductPrice], [isWeight], [barcode], [userDate])
                VALUES
                    (@name,@description, @categoryID, @subCategoryId, @price, @nameEn, @countryID, @companyID, @isHasFlavors, @isSpecial, @isVisible, @isProductPrice, @isWeight, @barcode, getdate()); SELECT @newID = SCOPE_IDENTITY()"
                UpdateCommand="
                delete from branchProducts where productID=@id;
                UPDATE [products]
                SET 
                    [name]           = @name,
                    [description]           = @description,
                    [categoryID]     = @categoryID,
                    [subCategoryId]     = @subCategoryId,
                    [price]          = @price,        
                    [nameEn]         = @nameEn,
                    [countryID]         = @countryID,
                    [companyID]         = @companyID,
                    [barcode]         = @barcode,
                    [isVisible]         = @isVisible,
                    [isProductPrice]         = @isProductPrice,
                    [isWeight]         = @isWeight,
                    [isHasFlavors]   = @isHasFlavors,
                    [isSpecial]   = @isSpecial
                WHERE [id] = @id;"
                DeleteCommand="Delete from products where id=@id;
                delete from branchproducts where productID=@id;
                "
                OnInserted="db_Products_Inserted">
                <InsertParameters>
                    <asp:Parameter Name="name" Type="String" />
                    <asp:Parameter Name="description" Type="String" />
                    <asp:Parameter Name="categoryID" Type="string" />
                    <asp:Parameter Name="subCategoryId" Type="string" />
                    <asp:Parameter Name="price" Type="string" />
                    <asp:Parameter Name="nameEn" Type="String" />
                    <asp:Parameter Name="isVisible" Type="Int32" />
                    <asp:Parameter Name="isProductPrice" Type="Int32" />
                    <asp:Parameter Name="isWeight" Type="Int32" />
                    <asp:Parameter Name="barcode" Type="String" />
                    <asp:Parameter Name="countryID" Type="String" />
                    <asp:Parameter Name="companyID" Type="String" />
                    <asp:Parameter Name="isHasFlavors" Type="string" />
                    <asp:Parameter Name="isSpecial" Type="string" />
                    <asp:Parameter Direction="Output" Name="newID" Type="Int32" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="id" />
                    <asp:Parameter Name="name" Type="String" />
                    <asp:Parameter Name="description" Type="String" />
                    <asp:Parameter Name="categoryID" Type="string" />
                    <asp:Parameter Name="subCategoryId" Type="string" />
                    <asp:Parameter Name="price" Type="string" />
                    <asp:Parameter Name="isVisible" Type="Int32" />
                    <asp:Parameter Name="isProductPrice" Type="Int32" />
                    <asp:Parameter Name="isWeight" Type="Int32" />
                    <asp:Parameter Name="barcode" Type="String" />
                    <asp:Parameter Name="nameEn" Type="String" />
                    <asp:Parameter Name="countryID" Type="String" />
                    <asp:Parameter Name="companyID" Type="String" />
                    <asp:Parameter Name="isHasFlavors" Type="string" />
                    <asp:Parameter Name="isSpecial" Type="string" />
                    <asp:Parameter Name="id" Type="Int32" />
                </UpdateParameters>
                <DeleteParameters>
                    <asp:Parameter Name="id" Type="Int32" />
                </DeleteParameters>
            </asp:SqlDataSource>

            <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_Del_Grids" CloseAnimationType="Slide"
                FooterText="" HeaderText="حذف منتج" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_Del_Products">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: right">
                            <div class="mb-3" style="width: 100%;">
                                <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف المنتج؟" ClientInstanceName="labelProducts"
                                    Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="labelProducts">
                                </dx:ASPxLabel>
                            </div>
                            <div style="width: 100%; margin-top: 20px; text-align: center;">
                                <dx:ASPxButton ID="Btn_Del_Products" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                                    <ClientSideEvents Click="function(s, e) { 
                                            GridProducts.DeleteRow(MyIndex); 
                                            setTimeout(function() { GridProducts.Refresh(); }, 200);
                                            Pop_Del_Grids.Hide();
                                        }" />
                                </dx:ASPxButton>

                                <dx:ASPxButton ID="Btn_Close_Products" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                    Style="margin-right: 20px;">
                                    <ClientSideEvents Click="function(s, e) {Pop_Del_Grids.Hide();}" />
                                </dx:ASPxButton>
                            </div>
                        </div>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>

            <%--this for Options--%>

            <dx:ASPxTextBox ID="l_item_file1" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file1" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_item_file_old1" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_old1" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_item_file_check1" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_check1" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>

            <%--this for Extras--%>

            <dx:ASPxTextBox ID="l_item_file2" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file2" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_item_file_old2" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_old2" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_item_file_check2" runat="server" BackColor="Transparent" ClientInstanceName="l_item_file_check2" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>


            <dx:ASPxTextBox ID="SelectedBranchIds" runat="server" BackColor="Transparent" ClientInstanceName="SelectedBranchIds" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_CountryID" runat="server" BackColor="Transparent" ClientInstanceName="l_CountryID" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_DefaultImage" runat="server" BackColor="Transparent" ClientInstanceName="l_DefaultImage" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_CompanyID" runat="server" BackColor="Transparent" ClientInstanceName="l_CompanyID" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="l_GridUpdating" runat="server" BackColor="Transparent" ClientInstanceName="l_GridUpdating" Font-Size="0pt" ForeColor="Transparent" Text="0" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>
            <dx:ASPxTextBox ID="chkUseTextState" runat="server"
                ClientInstanceName="chkUseTextState"
                ClientVisible="false"
                Text="0" />
            <dx:ASPxTextBox ID="comboNameValue" runat="server" ClientInstanceName="comboNameValue" ClientVisible="false" />
            <dx:ASPxTextBox ID="comboNameText" runat="server" ClientInstanceName="comboNameText" ClientVisible="false" />

            <dx:ASPxTextBox ID="l_Product_Id" runat="server" BackColor="Transparent" ClientInstanceName="l_Product_Id" Font-Size="0pt" ForeColor="Transparent" Text="" Width="0px" Theme="Default">
                <Border BorderStyle="None" BorderWidth="0px" />
            </dx:ASPxTextBox>

        </div>
        <dx:ASPxPopupControl ID="popupProductUsed" runat="server"
            ClientInstanceName="popupProductUsed"
            HeaderText="تنبيه"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            Modal="True"
            Width="400px"
            Height="150px"
            CloseAction="CloseButton"
            AllowDragging="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <div style="padding: 20px; text-align: center; font-family: 'Cairo', sans-serif; font-size: 1em;">
                        <p>لا يمكن حذف هذا المنتج لأنه مستخدم في سلة أو في طلب سابق.</p>
                        <dx:ASPxButton ID="btnClosePopup1" runat="server" Text="إغلاق" AutoPostBack="False"
                            Font-Names="Cairo"
                            Font-Size="1em">
                            <ClientSideEvents Click="function() { popupProductUsed.Hide(); }" />
                        </dx:ASPxButton>
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="popupValidationError" runat="server" Font-Names="cairo"
            ClientInstanceName="popupValidationError"
            ShowCloseButton="true"
            ShowHeader="true"
            HeaderText="خطأ في التحقق"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            Width="300px">
            <ContentCollection>
                <dx:PopupControlContentControl>
                    <dx:ASPxLabel ID="lblPopupMessage" runat="server" ClientInstanceName="lblPopupMessage" CssClass="error-popup-message" />
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

        <dx:ASPxPopupControl ID="popDetails" runat="server" Font-Names="cairo"
            ClientInstanceName="popDetails"
            ShowCloseButton="true"
            ShowHeader="true"
            HeaderText="الخيارات والإضافات"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            BackColor="#E2E2E2">
            <ClientSideEvents Init="PopOnInit" Shown="function(s, e){                   
                    pageTab.SetActiveTabIndex(0);
                    setTimeout(function () {
                         GridProductsOptions.Refresh();
                         GridProductsExtras.Refresh();
                    }, 100);
                    setTimeout(function () {
                         popDetails.UpdatePosition();
                    }, 1000);
                 }" />
            <ContentCollection>
                <dx:PopupControlContentControl>


                    <dx:ASPxPageControl ID="pageTab" runat="server" CssClass="divSTARProviders" ActiveTabIndex="1" ClientInstanceName="pageTab" Theme="Material" Width="100%" EnableCallbackAnimation="True">
                        <TabPages>
                            <dx:TabPage Text="الخيارات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Larger">
                                <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="Larger"></TabStyle>
                                <ContentCollection>
                                    <dx:ContentControl runat="server">

                                        <script>

                                            var MyId1;
                                            var MyIndex1;

                                            function OnRowClickOptions(s, e) {
                                                MyIndex1 = e.visibleIndex;
                                                GridProductsOptions.GetRowValues(e.visibleIndex, 'id;imagePath', GetRowValues1);
                                            }

                                            function GetRowValues1(values) {
                                                MyId1 = values[0];
                                                l_item_file1.SetText(values[1]);
                                                l_item_file_old1.SetText(values[1]);
                                            }

                                            function OnGridBeginCallback1(s, e) {
                                                if (e.command == 'STARTEDIT') {
                                                    l_item_file_check1.SetText('0');
                                                }
                                                if (e.command == 'ADDNEWROW') {
                                                    MyId1 = 0;
                                                    l_item_file1.SetText('');
                                                    l_item_file_old1.SetText('');
                                                }
                                                if (e.command == 'UPDATEEDIT') {
                                                }
                                                if (e.command == 'DELETEROW') {
                                                }
                                            }
                                            function onFileUploadComplete1(s, e) {
                                                var fileData = e.callbackData.split('|');
                                                var fileName = fileData[0];
                                                if (document.getElementById("DocsFile-" + MyId1) != null) {
                                                    document.getElementById("DocsFile-" + MyId1).src = fileName;
                                                    document.getElementById("DocsFileLarge-" + MyId1).src = fileName;
                                                }
                                                else {
                                                    document.getElementById("DocsFileLarge-").src = fileName;
                                                }
                                                l_item_file1.SetText(fileName);
                                                l_item_file_check1.SetText('1');
                                                MyId1 = 0;
                                            }

                                            function onFileUploadStart1(s, e) {
                                                l_item_file_check1.SetText('0');
                                            }

                                            //-------------------------------------------------------------//

                                            var MyId2;
                                            var MyIndex2;

                                            function OnRowClickExtras(s, e) {
                                                MyIndex2 = e.visibleIndex;
                                                GridProductsExtras.GetRowValues(e.visibleIndex, 'id;imagePath', GetRowValues2);
                                            }

                                            function GetRowValues2(values) {
                                                MyId2 = values[0];
                                                l_item_file2.SetText(values[1]);
                                                l_item_file_old2.SetText(values[1]);
                                            }

                                            function OnGridBeginCallback2(s, e) {
                                                if (e.command == 'STARTEDIT') {
                                                    l_item_file_check2.SetText('0');
                                                }
                                                if (e.command == 'ADDNEWROW') {
                                                    MyId2 = 0;
                                                    l_item_file2.SetText('');
                                                    l_item_file_old2.SetText('');
                                                }
                                                if (e.command == 'UPDATEEDIT') {
                                                }
                                                if (e.command == 'DELETEROW') {
                                                }
                                            }
                                            function onFileUploadComplete2(s, e) {
                                                var fileData = e.callbackData.split('|');
                                                var fileName = fileData[0];
                                                if (document.getElementById("DocsFile-" + MyId2) != null) {
                                                    document.getElementById("DocsFile-" + MyId2).src = fileName;
                                                    document.getElementById("DocsFileLarge-" + MyId2).src = fileName;
                                                }
                                                else {
                                                    document.getElementById("DocsFileLarge-").src = fileName;
                                                }
                                                l_item_file2.SetText(fileName);
                                                l_item_file_check2.SetText('1');
                                                MyId2 = 0;
                                            }
                                            function onFileUploadStart2(s, e) {
                                                l_item_file_check2.SetText('0');
                                            }


                                            var MyId1;
                                            var MyIndex1;

                                            function OnRowClickOptions(s, e) {
                                                MyIndex1 = e.visibleIndex;
                                                GridProductsOptions.GetRowValues(e.visibleIndex, 'id;imagePath', GetRowValues1);
                                            }

                                            function GetRowValues1(values) {
                                                MyId1 = values[0];
                                                l_item_file1.SetText(values[1]);
                                                l_item_file_old1.SetText(values[1]);
                                            }

                                            function OnGridBeginCallback1(s, e) {
                                                if (e.command == 'STARTEDIT') {
                                                    l_item_file_check1.SetText('0');
                                                }
                                                if (e.command == 'ADDNEWROW') {
                                                    MyId1 = 0;
                                                    l_item_file1.SetText('');
                                                    l_item_file_old1.SetText('');
                                                }
                                                if (e.command == 'UPDATEEDIT') {
                                                }
                                                if (e.command == 'DELETEROW') {
                                                }
                                            }
                                            function onFileUploadComplete1(s, e) {
                                                var fileData = e.callbackData.split('|');
                                                var fileName = fileData[0];
                                                if (document.getElementById("DocsFile-" + MyId1) != null) {
                                                    document.getElementById("DocsFile-" + MyId1).src = fileName;
                                                    document.getElementById("DocsFileLarge-" + MyId1).src = fileName;
                                                }
                                                else {
                                                    document.getElementById("DocsFileLarge-").src = fileName;
                                                }
                                                l_item_file1.SetText(fileName);
                                                l_item_file_check1.SetText('1');
                                                MyId1 = 0;
                                            }

                                            function onFileUploadStart1(s, e) {
                                                l_item_file_check1.SetText('0');
                                            }

                                            //-------------------------------------------------------------//

                                            var MyId2;
                                            var MyIndex2;

                                            function OnRowClickExtras(s, e) {
                                                MyIndex2 = e.visibleIndex;
                                                GridProductsExtras.GetRowValues(e.visibleIndex, 'id;imagePath', GetRowValues2);
                                            }

                                            function GetRowValues2(values) {
                                                MyId2 = values[0];
                                                l_item_file2.SetText(values[1]);
                                                l_item_file_old2.SetText(values[1]);
                                            }

                                            function OnGridBeginCallback2(s, e) {
                                                if (e.command == 'STARTEDIT') {
                                                    l_item_file_check2.SetText('0');
                                                }
                                                if (e.command == 'ADDNEWROW') {
                                                    MyId2 = 0;
                                                    l_item_file2.SetText('');
                                                    l_item_file_old2.SetText('');
                                                }
                                                if (e.command == 'UPDATEEDIT') {
                                                }
                                                if (e.command == 'DELETEROW') {
                                                }
                                            }
                                            function onFileUploadComplete2(s, e) {
                                                var fileData = e.callbackData.split('|');
                                                var fileName = fileData[0];
                                                if (document.getElementById("DocsFile-" + MyId2) != null) {
                                                    document.getElementById("DocsFile-" + MyId2).src = fileName;
                                                    document.getElementById("DocsFileLarge-" + MyId2).src = fileName;
                                                }
                                                else {
                                                    document.getElementById("DocsFileLarge-").src = fileName;
                                                }
                                                l_item_file2.SetText(fileName);
                                                l_item_file_check2.SetText('1');
                                                MyId2 = 0;
                                            }
                                            function onFileUploadStart2(s, e) {
                                                l_item_file_check2.SetText('0');
                                            }

                                            function ConfirmCancelOffer() {
                                                var optionId = GridProductsOptions.cpOptionId;
                                                if (optionId) {
                                                    GridProductsOptions.PerformCallback("cancelOffer|" + optionId);
                                                }
                                                popupCancelOffer.Hide();
                                            }

                                        </script>

                                        <div style="background-color: #ff0000; border: 1px solid #ff0000; margin: 0 auto; text-align: center; font-family: Cairo; font-size: 1em; font-weight: 800; padding-bottom: 0.1em; padding-top: 0; color: #78ff00">
                                            يمكن للمشتري اختيار خيار واحد فقط، سعر الخيار إما سعر المنتج المعروض في الخيارات أو زيادة على سعر المنتج الأصلي ويمكن تغيير نوع الخيار إما يعرض سعر أو زيادة على السعر بتعديل المنتج وتغيير قيمة الحقل (سعر أم زيادة)                                       
                                        </div>

                                        <div style="box-shadow: 0 0 13px 2px rgba(130, 130, 130, 0.61);">

                                            <dx:ASPxGridView ID="GridProductsOptions" runat="server" DataSourceID="db_ProductsOptions" KeyFieldName="id" ClientInstanceName="GridProductsOptions" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" Font-Bold="True" OnCancelRowEditing="GridProductsOptions_CancelRowEditing" OnRowDeleting="GridProductsOptions_RowDeleting" OnRowUpdated="GridProductsOptions_RowUpdated" OnRowUpdating="GridProductsOptions_RowUpdating" OnCustomCallback="GridProductsOptions_CustomCallback">
                                                <SettingsPager PageSize="3">
                                                </SettingsPager>
                                                <Settings ShowFooter="True" ShowFilterRow="True" />


                                                <ClientSideEvents BeginCallback="OnGridBeginCallback1" EndCallback="function(s,e){
                                                    if(s.cpShowCancelOfferPopup === 'true'){
                                                        popupCancelOffer.Show();
                                                        // reset flag عشان ما يضل يطلع
                                                        s.cpShowCancelOfferPopup = null;
                                                    }
                                                    if(s.cpCanceled === 'true'){
                                                        console.log('chocolate');
                                                        s.UpdateEdit();
                                                        s.cpCanceled = null;
                                                    }
                                                    if (s.cpShowUsedPopup === 'true') {
                                                        popupOptionUsed.Show();
                                                        console.log('bukaayoooooooo saka ')
                                                        s.cpShowUsedPopup = null;
                                                    }
                                                }"
                                                    RowClick="function(s, e) {OnRowClickDetail(e); OnRowClickOptions(s,e);}" RowDblClick="function(s, e) {setTimeout(function(){GridProductsOptions.StartEditRow(MyIndex);},100);}" />
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells">
                                                </SettingsAdaptivity>
                                                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد">
                                                    </NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png">
                                                        </Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>

                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>

                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch3" />

                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id" Width="1%">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                                        </CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الصورة" FieldName="imagePath" EditFormSettings-VisibleIndex="1" EditFormSettings-Caption=" " Width="3%">
                                                        <EditFormSettings RowSpan="3" VisibleIndex="1" Caption=" "></EditFormSettings>
                                                        <DataItemTemplate>
                                                            <div style="text-align: center; width: 100%">
                                                                <img id="<%# "DocsFile-" + Eval("id") %>" src="<%# (!string.IsNullOrEmpty(Eval("imagePath").ToString()) ? Eval("imagePath") : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 5em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <CellStyle VerticalAlign="Middle">
                                                        </CellStyle>

                                                        <EditItemTemplate>
                                                            <div style="text-align: center; width: 90%">
                                                                <img id="<%# "DocsFileLarge-" + Eval("id") %>" src="<%# (Eval("imagePath") != null && Eval("imagePath").ToString().Length > 1 ? Eval("imagePath").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 11em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                                <dx:ASPxUploadControl ID="poorImageUpload" runat="server" ClientInstanceName="poorImageUpload" FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em" OnFileUploadComplete="ImageUpload_FileUploadComplete1" ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                                    <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="5048576" MaxFileSizeErrorText="حجم الصورة أكبر من 1 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                                                                    </ValidationSettings>
                                                                    <ClientSideEvents FilesUploadStart="onFileUploadStart1" FileUploadComplete="onFileUploadComplete1" />
                                                                    <BrowseButton Text="اختيــــــــار">
                                                                    </BrowseButton>
                                                                    <CancelButton Text="إلغاء التحميل">
                                                                    </CancelButton>
                                                                    <NullTextStyle Font-Names="Cairo">
                                                                    </NullTextStyle>
                                                                </dx:ASPxUploadControl>
                                                            </div>
                                                        </EditItemTemplate>

                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="الخيار" FieldName="productOption">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                                <RequiredField IsRequired="True"></RequiredField>
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                                        </CellStyle>
                                                    </dx:GridViewDataTextColumn>

                                                    <dx:GridViewDataSpinEditColumn Caption="السعر" FieldName="productOptionPrice" Width="3%">
                                                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="14" NullDisplayText="0">
                                                            <ValidationSettings Display="Dynamic" SetFocusOnError="True">
                                                                <RequiredField ErrorText="الرجاء إدخال السعر" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </PropertiesSpinEdit>
                                                        <EditFormSettings Visible="True" />
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                        </CellStyle>
                                                    </dx:GridViewDataSpinEditColumn>
                                                    <dx:GridViewDataSpinEditColumn Caption="الباركود" FieldName="barcode" Width="3%">
                                                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="30" NullDisplayText="0">
                                                            <ValidationSettings Display="Dynamic" SetFocusOnError="True">
                                                                <RequiredField ErrorText="الرجاء إدخال الباركود" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </PropertiesSpinEdit>
                                                        <EditFormSettings Visible="True" />
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                        </CellStyle>
                                                    </dx:GridViewDataSpinEditColumn>


                                                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                                                        <EditFormSettings Visible="False" />
                                                        <DataItemTemplate>
                                                            <div style="width: 100%; float: left; text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridProductsOptions.StartEditRow(MyIndexDetail);},100);" />
                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="Pop_DetailsDel.Show();" />

                                                            </div>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>

                                                </Columns>
                                                <Toolbars>
                                                    <dx:GridViewToolbar ItemAlign="left">
                                                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                                        <Items>
                                                            <dx:GridViewToolbarItem Command="New" Text="جديد" />
                                                            <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Text="تحديث الجدول" />
                                                            <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                                                            <dx:GridViewToolbarItem Command="ExportToPdf" />

                                                            <dx:GridViewToolbarItem Alignment="Right" Name="toolbarItemSearch" BeginGroup="true" AdaptivePriority="2">
                                                                <Template>
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch3" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>

                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>
                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>
                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0">
                                                    </AlternatingRow>
                                                    <Footer Font-Names="cairo">
                                                    </Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />

                                            </dx:ASPxGridView>

                                            <dx:ASPxPopupControl ID="popupOptionUsed" runat="server"
                                                ClientInstanceName="popupOptionUsed"
                                                HeaderText="تنبيه"
                                                PopupHorizontalAlign="WindowCenter"
                                                PopupVerticalAlign="WindowCenter"
                                                Modal="True"
                                                Width="400px"
                                                Height="150px"
                                                CloseAction="CloseButton"
                                                AllowDragging="True">
                                                <ContentCollection>
                                                    <dx:PopupControlContentControl runat="server">
                                                        <div style="padding: 20px; text-align: center; font-family: 'Cairo', sans-serif; font-size: 1em;">
                                                            <p>لا يمكن حذف هذا الخيار لأنه مستخدم في سلة أو في طلب سابق.</p>
                                                            <dx:ASPxButton ID="btnClosePopup" runat="server" Text="إغلاق" AutoPostBack="False"
                                                                Font-Names="Cairo"
                                                                Font-Size="1em">
                                                                <ClientSideEvents Click="function() { popupOptionUsed.Hide(); }" />
                                                            </dx:ASPxButton>
                                                        </div>
                                                    </dx:PopupControlContentControl>
                                                </ContentCollection>
                                            </dx:ASPxPopupControl>




                                            <asp:SqlDataSource
                                                ID="db_ProductsOptions"
                                                runat="server"
                                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                                SelectCommand="SELECT [id], [productOption],[imagePath], [productOptionPrice],[offerPrice] ,[productId], [barcode] FROM [productsOptions] Where productId = @productId"
                                                InsertCommand="INSERT INTO [productsOptions] ([productOption],[imagePath] ,[productOptionPrice], [productId], [barcode], [userDate]) VALUES (@productOption,@imagePath, @productOptionPrice, @productId, @barcode, getdate());"
                                                UpdateCommand="UPDATE [productsOptions] SET [productOption] = @productOption, [productOptionPrice] = @productOptionPrice ,[imagePath] =@imagePath, [barcode]=@barcode WHERE [id] = @id;"
                                                DeleteCommand="DELETE FROM [productsOptions] WHERE [id] = @id;">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="l_Product_Id" Name="productId" PropertyName="Text" />
                                                </SelectParameters>
                                                <InsertParameters>
                                                    <asp:Parameter Name="productOption" Type="String" />
                                                    <asp:Parameter Name="productOptionPrice" Type="String" />
                                                    <asp:Parameter Name="barcode" Type="String" />
                                                    <asp:ControlParameter ControlID="l_Product_Id" Name="productId" PropertyName="Text" />
                                                    <asp:ControlParameter ControlID="l_item_file1" Name="imagePath" PropertyName="Text" />
                                                </InsertParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="productOption" Type="String" />
                                                    <asp:Parameter Name="productOptionPrice" Type="String" />
                                                    <asp:Parameter Name="barcode" Type="String" />
                                                    <asp:Parameter Name="id" Type="Int32" />
                                                    <asp:ControlParameter ControlID="l_item_file1" Name="imagePath" PropertyName="Text" />
                                                </UpdateParameters>
                                                <DeleteParameters>
                                                    <asp:Parameter Name="id" Type="Int32" />
                                                </DeleteParameters>

                                            </asp:SqlDataSource>


                                            <dx:ASPxPopupControl ID="popupCancelOffer" runat="server"
                                                ClientInstanceName="popupCancelOffer"
                                                PopupHorizontalAlign="WindowCenter"
                                                PopupVerticalAlign="WindowCenter"
                                                HeaderText="تنبيه"
                                                Modal="True"
                                                Font-Names="Cairo"
                                                ShowCloseButton="True"
                                                Width="400px">

                                                <ContentCollection>
                                                    <dx:PopupControlContentControl>
                                                        <div style="font-family: Cairo; font-size: 1.3em; direction: rtl; text-align: center; padding: 1.5em;">
                                                            <p style="margin-bottom: 0.5em;">
                                                                هذا الخيار يحتوي على <b>عرض مفعّل</b> في قسم العروض.
                                                            </p>
                                                            <p>
                                                                هل تريد حفظ سعر الخيار الجديد وإلغاء العرض التابع له؟
                                                            </p>

                                                            <div style="text-align: center; margin-top: 25px;">
                                                                <dx:ASPxButton ID="btnConfirmCancel" runat="server" Text="نعم" Font-Names="Cairo" AutoPostBack="False">
                                                                    <ClientSideEvents Click="function(s,e){
                GridProductsOptions.PerformCallback('cancelOffer|' + GridProductsOptions.cpOptionId);
                popupCancelOffer.Hide();
            }" />
                                                                </dx:ASPxButton>

                                                                <dx:ASPxButton ID="btnAbort" runat="server" Text="لا" Font-Names="Cairo" AutoPostBack="False" Style="margin-right: 10px;">
                                                                    <ClientSideEvents Click="function(s,e){ popupCancelOffer.Hide(); GridProductsOptions.CancelEdit(); }" />
                                                                </dx:ASPxButton>
                                                            </div>
                                                        </div>

                                                    </dx:PopupControlContentControl>
                                                </ContentCollection>
                                            </dx:ASPxPopupControl>

                                            <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_DetailsDel" CloseAnimationType="Slide"
                                                FooterText="" HeaderText="حذف خيار لمنتج" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_DetailsDel">
                                                <ContentCollection>
                                                    <dx:PopupControlContentControl runat="server">
                                                        <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: right">
                                                            <div class="mb-3" style="width: 100%;">
                                                                <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف الخيار؟" ClientInstanceName="labelProducts"
                                                                    Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="ASPxLabel1">
                                                                </dx:ASPxLabel>
                                                            </div>
                                                            <div style="width: 100%; margin-top: 20px; text-align: center;">
                                                                <dx:ASPxButton ID="ASPxButton1" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                                                                    <ClientSideEvents Click="function(s, e) { 
                                                                            GridProductsOptions.DeleteRow(MyIndexDetail); 
                                                                            Pop_DetailsDel.Hide();
                                                                        }" />
                                                                </dx:ASPxButton>

                                                                <dx:ASPxButton ID="ASPxButton2" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                                                    Style="margin-right: 20px;">
                                                                    <ClientSideEvents Click="function(s, e) {Pop_DetailsDel.Hide();}" />
                                                                </dx:ASPxButton>
                                                            </div>
                                                        </div>
                                                    </dx:PopupControlContentControl>
                                                </ContentCollection>
                                            </dx:ASPxPopupControl>

                                        </div>

                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                            <dx:TabPage Text="الإضافات" TabStyle-Font-Bold="true" TabStyle-Font-Names="cairo" TabStyle-Font-Size="Larger">
                                <TabStyle Font-Bold="True" Font-Names="cairo" Font-Size="Larger"></TabStyle>
                                <ContentCollection>
                                    <dx:ContentControl runat="server">


                                        <div style="background-color: #ff0000; border: 1px solid #ff0000; margin: 0 auto; text-align: center; font-family: Cairo; font-size: 1em; font-weight: 800; padding-bottom: 0.1em; padding-top: 0; color: #78ff00">
                                            يمكن للمشتري اختيار أكثر من إضافة في نفس الوقت، سعر كل إضافة هي زيادة على سعر المنتج الأصلي
                                        </div>


                                        <div style="box-shadow: 0 0 13px 2px rgba(130, 130, 130, 0.61);">

                                            <dx:ASPxGridView ID="GridProductsExtras" runat="server" DataSourceID="db_ProductsExtras" KeyFieldName="id" ClientInstanceName="GridProductsExtras" Width="100%" AutoGenerateColumns="False" EnablePagingCallbackAnimation="True" Font-Names="cairo" Font-Size="1em" RightToLeft="True" Font-Bold="True" OnCancelRowEditing="GridProductsExtras_CancelRowEditing" OnRowDeleting="GridProductsExtras_RowDeleting" OnRowUpdated="GridProductsExtras_RowUpdated">
                                                <SettingsPager PageSize="3">
                                                </SettingsPager>
                                                <Settings ShowFooter="True" ShowFilterRow="True" />


                                                <ClientSideEvents BeginCallback="OnGridBeginCallback" RowClick="function(s, e) {OnRowClickDetail(e); OnRowClickExtras(s,e);}" RowDblClick="function(s, e) {setTimeout(function(){GridProductsExtras.StartEditRow(MyIndex);},100);}" />
                                                <SettingsAdaptivity AdaptivityMode="HideDataCells">
                                                </SettingsAdaptivity>
                                                <Settings ShowFilterRow="True" ShowFilterRowMenu="False" ShowHeaderFilterButton="False" AutoFilterCondition="Contains" />

                                                <SettingsCommandButton>
                                                    <NewButton Text="جديد">
                                                    </NewButton>
                                                    <UpdateButton Text=" حفظ ">
                                                        <Image Url="~/assets/img/save.png" SpriteProperties-Left="50">
                                                            <SpriteProperties Left="50px"></SpriteProperties>
                                                        </Image>
                                                    </UpdateButton>
                                                    <CancelButton Text=" الغاء ">
                                                        <Image Url="~/assets/img/cancel.png">
                                                        </Image>
                                                    </CancelButton>
                                                </SettingsCommandButton>

                                                <SettingsPopup>
                                                    <FilterControl AutoUpdatePosition="False"></FilterControl>
                                                </SettingsPopup>

                                                <SettingsSearchPanel CustomEditorID="tbToolbarSearch3" />

                                                <SettingsExport EnableClientSideExportAPI="true" ExcelExportMode="WYSIWYG" PaperKind="A4" RightToLeft="True" />
                                                <SettingsLoadingPanel Text="Please Wait &amp;hellip;" Mode="ShowAsPopup" />
                                                <SettingsText SearchPanelEditorNullText="ابحث في الجدول..." EmptyDataRow="لا يوجد" />
                                                <Columns>

                                                    <dx:GridViewDataColumn Caption="الرقم" FieldName="id" Width="1%">
                                                        <EditFormSettings Visible="False" />
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                                        </CellStyle>
                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataColumn Caption="الصورة" FieldName="imagePath" EditFormSettings-VisibleIndex="1" EditFormSettings-Caption=" " Width="3%">
                                                        <EditFormSettings RowSpan="3" VisibleIndex="1" Caption=" "></EditFormSettings>
                                                        <DataItemTemplate>
                                                            <div style="text-align: center; width: 100%">
                                                                <img id="<%# "DocsFile-" + Eval("id") %>" src="<%# (!string.IsNullOrEmpty(Eval("imagePath").ToString()) ? Eval("imagePath") : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 5em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                            </div>
                                                        </DataItemTemplate>
                                                        <CellStyle VerticalAlign="Middle">
                                                        </CellStyle>

                                                        <EditItemTemplate>
                                                            <div style="text-align: center; width: 90%">
                                                                <img id="<%# "DocsFileLarge-" + Eval("id") %>" src="<%# (Eval("imagePath") != null && Eval("imagePath").ToString().Length > 1 ? Eval("imagePath").ToString() : "/assets/uploads/noFile.png") + "?v=" + DateTime.Now.Ticks %>" style="width: 11em; border: 1px solid #c8c8c8; border-radius: 5px;" />
                                                                <dx:ASPxUploadControl ID="poorImageUpload" runat="server" ClientInstanceName="poorImageUpload" FileUploadMode="OnPageLoad" Font-Names="Cairo" Font-Size="1em" OnFileUploadComplete="ImageUpload_FileUploadComplete2" ShowProgressPanel="True" UploadMode="Auto" Width="100%" AutoStartUpload="True">
                                                                    <ValidationSettings AllowedFileExtensions=".jpg, .jpeg, .png, .bmp" GeneralErrorText="حدث خطأ أثناء تحميل الصور ، الرجاء المحاولة لاحقا" MaxFileSize="5048576" MaxFileSizeErrorText="حجم الصورة أكبر من 1 ميجابايت ، الرجاء اختيار صورة بحجم أقل" NotAllowedFileExtensionErrorText="امتداد الصورة غير مسموح به">
                                                                    </ValidationSettings>
                                                                    <ClientSideEvents FilesUploadStart="onFileUploadStart2" FileUploadComplete="onFileUploadComplete2" />
                                                                    <BrowseButton Text="اختيــــــــار">
                                                                    </BrowseButton>
                                                                    <CancelButton Text="إلغاء التحميل">
                                                                    </CancelButton>
                                                                    <NullTextStyle Font-Names="Cairo">
                                                                    </NullTextStyle>
                                                                </dx:ASPxUploadControl>
                                                            </div>
                                                        </EditItemTemplate>

                                                    </dx:GridViewDataColumn>

                                                    <dx:GridViewDataTextColumn Caption="الإضافة" FieldName="productExtra">
                                                        <PropertiesTextEdit>
                                                            <ValidationSettings RequiredField-IsRequired="true" SetFocusOnError="True" ErrorText="required." Display="Dynamic">
                                                                <RequiredField IsRequired="True"></RequiredField>
                                                            </ValidationSettings>
                                                        </PropertiesTextEdit>
                                                        <CellStyle VerticalAlign="Middle" HorizontalAlign="Center">
                                                        </CellStyle>
                                                    </dx:GridViewDataTextColumn>

                                                    <dx:GridViewDataSpinEditColumn Caption="سعر الزيادة" FieldName="productExtraPrice" Width="3%">
                                                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="14" NullDisplayText="0">
                                                            <ValidationSettings Display="Dynamic" SetFocusOnError="True">
                                                                <RequiredField ErrorText="الرجاء إدخال السعر" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </PropertiesSpinEdit>
                                                        <EditFormSettings Visible="True" />
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                        </CellStyle>
                                                    </dx:GridViewDataSpinEditColumn>
                                                    <dx:GridViewDataSpinEditColumn Caption="الباركود" FieldName="barcode" Width="3%">
                                                        <PropertiesSpinEdit DisplayFormatString="g" MaxLength="30" NullDisplayText="0">
                                                            <ValidationSettings Display="Dynamic" SetFocusOnError="True">
                                                                <RequiredField ErrorText="الرجاء إدخال الباركود" IsRequired="True" />
                                                            </ValidationSettings>
                                                        </PropertiesSpinEdit>
                                                        <EditFormSettings Visible="True" />
                                                        <CellStyle HorizontalAlign="Center" VerticalAlign="Middle">
                                                        </CellStyle>
                                                    </dx:GridViewDataSpinEditColumn>


                                                    <dx:GridViewDataTextColumn Caption="" ShowInCustomizationForm="True" Width="100px">
                                                        <EditFormSettings Visible="False" />
                                                        <DataItemTemplate>
                                                            <div style="width: 100%; float: left; text-align: center">
                                                                <img src="/assets/img/update.png" width="32" height="32" title="تعديل" style="cursor: pointer" onclick="setTimeout(function(){GridProductsExtras.StartEditRow(MyIndexDetail);},100);" />
                                                                <img src="/assets/img/delete.png" width="32" height="32" title="حذف" style="cursor: pointer" onclick="Pop_ExtrasDel.Show();" />

                                                            </div>
                                                        </DataItemTemplate>
                                                    </dx:GridViewDataTextColumn>

                                                </Columns>
                                                <Toolbars>
                                                    <dx:GridViewToolbar ItemAlign="left">
                                                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                                        <Items>
                                                            <dx:GridViewToolbarItem Command="New" Text="جديد" />
                                                            <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Text="تحديث الجدول" />
                                                            <dx:GridViewToolbarItem Command="ExportToXlsx" BeginGroup="true" />
                                                            <dx:GridViewToolbarItem Command="ExportToPdf" />

                                                            <dx:GridViewToolbarItem Alignment="Right" Name="toolbarItemSearch" BeginGroup="true" AdaptivePriority="2">
                                                                <Template>
                                                                    <dx:ASPxButtonEdit ID="tbToolbarSearch3" runat="server" NullText="البحث..." Width="140" Font-Names="cairo" />
                                                                </Template>
                                                            </dx:GridViewToolbarItem>

                                                        </Items>
                                                    </dx:GridViewToolbar>
                                                </Toolbars>
                                                <TotalSummary>
                                                    <dx:ASPxSummaryItem FieldName="id" SummaryType="Count" DisplayFormat="العدد = {0}" />
                                                </TotalSummary>
                                                <Styles>
                                                    <AlternatingRow BackColor="#F0F0F0">
                                                    </AlternatingRow>
                                                    <Footer Font-Names="cairo">
                                                    </Footer>
                                                </Styles>
                                                <Paddings Padding="2em" />

                                            </dx:ASPxGridView>

                                            <asp:SqlDataSource
                                                ID="db_ProductsExtras"
                                                runat="server"
                                                ConnectionString="<%$ ConnectionStrings:ShabDB_connection %>"
                                                SelectCommand="SELECT [id], [productExtra],[imagePath], [productExtraPrice], [productId], [barcode] FROM [productsExtra] Where productId = @productId"
                                                InsertCommand="INSERT INTO [productsExtra] ([productExtra],[imagePath], [productExtraPrice], [productId], [barcode], [userDate]) VALUES (@productExtra,@imagePath, @productExtraPrice, @productId, @barcode, getdate());"
                                                UpdateCommand="UPDATE [productsExtra] SET [productExtra] = @productExtra, [productExtraPrice] = @productExtraPrice, [imagePath] = @imagePath, [barcode]=@barcode WHERE [id] = @id;"
                                                DeleteCommand="DELETE FROM [productsExtra] WHERE [id] = @id;">
                                                <SelectParameters>
                                                    <asp:ControlParameter ControlID="l_Product_Id" Name="productId" PropertyName="Text" />
                                                </SelectParameters>
                                                <InsertParameters>
                                                    <asp:Parameter Name="productExtra" Type="String" />
                                                    <asp:Parameter Name="productExtraPrice" Type="String" />
                                                    <asp:Parameter Name="barcode" Type="String" />
                                                    <asp:ControlParameter ControlID="l_Product_Id" Name="productId" PropertyName="Text" />
                                                    <asp:ControlParameter ControlID="l_item_file2" Name="imagePath" PropertyName="Text" />
                                                </InsertParameters>
                                                <UpdateParameters>
                                                    <asp:Parameter Name="productExtra" Type="String" />
                                                    <asp:Parameter Name="productExtraPrice" Type="String" />
                                                    <asp:Parameter Name="barcode" Type="String" />
                                                    <asp:Parameter Name="id" Type="Int32" />
                                                    <asp:ControlParameter ControlID="l_item_file2" Name="imagePath" PropertyName="Text" />
                                                </UpdateParameters>
                                                <DeleteParameters>
                                                    <asp:Parameter Name="id" Type="Int32" />
                                                </DeleteParameters>

                                            </asp:SqlDataSource>

                                            <dx:ASPxPopupControl runat="server" PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
                                                AutoUpdatePosition="True" Modal="True" ClientInstanceName="Pop_ExtrasDel" CloseAnimationType="Slide"
                                                FooterText="" HeaderText="حذف إضافة لمنتج" Font-Names="Cairo" MinWidth="350px" MinHeight="150px" Width="350px" Height="150px" ID="Pop_ExtrasDel">
                                                <ContentCollection>
                                                    <dx:PopupControlContentControl runat="server">
                                                        <div style="padding: 20px; font-family: 'Cairo', sans-serif; text-align: right">
                                                            <div class="mb-3" style="width: 100%;">
                                                                <dx:ASPxLabel runat="server" Text="هل أنت متأكد من حذف الإضافة؟" ClientInstanceName="labelProducts"
                                                                    Font-Names="Cairo" Font-Size="Medium" ForeColor="#333333" ID="ASPxLabel2">
                                                                </dx:ASPxLabel>
                                                            </div>
                                                            <div style="width: 100%; margin-top: 20px; text-align: center;">
                                                                <dx:ASPxButton ID="ASPxButton3" runat="server" AutoPostBack="False" Text="حــــــــذف"
                                                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle">
                                                                    <ClientSideEvents Click="function(s, e) { 
                                                                            GridProductsExtras.DeleteRow(MyIndexDetail); 
                                                                            Pop_ExtrasDel.Hide();
                                                                        }" />
                                                                </dx:ASPxButton>

                                                                <dx:ASPxButton ID="ASPxButton4" runat="server" AutoPostBack="False" Text="إغـــــــــــلاق"
                                                                    UseSubmitBehavior="False" Font-Names="Cairo" HorizontalAlign="Center" VerticalAlign="Middle"
                                                                    Style="margin-right: 20px;">
                                                                    <ClientSideEvents Click="function(s, e) {Pop_ExtrasDel.Hide();}" />
                                                                </dx:ASPxButton>
                                                            </div>
                                                        </div>
                                                    </dx:PopupControlContentControl>
                                                </ContentCollection>
                                            </dx:ASPxPopupControl>

                                        </div>

                                    </dx:ContentControl>
                                </ContentCollection>
                            </dx:TabPage>
                        </TabPages>
                    </dx:ASPxPageControl>

                </dx:PopupControlContentControl>
            </ContentCollection>
            <BackgroundImage ImageUrl="~/assets/img/back.png" />
        </dx:ASPxPopupControl>


        <dx:ASPxPopupControl
            ID="ImagePopup"
            runat="server"
            ClientInstanceName="ImagePopup"
            Modal="True"
            ShowCloseButton="True"
            Width="800px"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            HeaderText="عرض صور المنتج">

            <ClientSideEvents Shown="function(s, e) { s.UpdatePosition(); }" />

            <ContentCollection>
                <dx:PopupControlContentControl>

                    <dx:ASPxCallback ID="callbackSetDefault" runat="server"
                        ClientInstanceName="callbackSetDefault"
                        OnCallback="callbackSetDefault_Callback"
                        Style="display: none;">
                        <ClientSideEvents EndCallback="
                                function(s, e) {
                                  // 1) grab the new default path your server pushed back
                                  var newPath = s.cp_newDefault;
                                  if(!newPath) return;

                                  // 2) patch the one thumbnail in the grid row
                                  var row = GridProducts.GetRow(currentRowIndex);
                                  if(row) {
                                    var thumb = row.querySelector('.preview-container img');
                                    if(thumb) {
                                      thumb.src = newPath + '?v=' + new Date().getTime();
                                    }
                                  }
                                }" />
                    </dx:ASPxCallback>

                    <dx:ASPxCallbackPanel ID="callbackImagePanel" runat="server"
                        ClientInstanceName="callbackImagePanel"
                        OnCallback="callbackImagePanel_Callback"
                        ClientSideEvents-EndCallback="function() { renderMakeDefaultButtons(); }">
                        <ClientSideEvents EndCallback="function(s,e){ ImagePopup.Show();}" />

                        <PanelCollection>
                            <dx:PanelContent>
                                <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; width: 100%; height: 100%; padding: 1rem;">

                                    <div style="box-shadow: 0 4px 12px rgba(0,0,0,0.2); border-radius: 12px; overflow: hidden; width: 500px; height: 500px; background-color: #f9f9f9; display: flex; align-items: center; justify-content: center;">
                                        <dx:ASPxImageSlider
                                            ID="ImageSlider"
                                            runat="server"
                                            ClientInstanceName="ImageSlider"
                                            Width="100%"
                                            Height="100%"
                                            SlideWidth="100%"
                                            SlideHeight="100%"
                                            Stretch="Uniform" />
                                    </div>

                                    <div style="text-align: center; margin-top: 1rem;">
                                        <button type="button" onclick="makeCurrentDefault()" style="padding: 0.5rem 1.5rem; background-color: #007bff; color: white; border: none; border-radius: 8px; font-family: 'Cairo', sans-serif; font-size: 1rem; cursor: pointer;">
                                            تعيين كصورة رئيسية
                               
                                        </button>
                                    </div>

                                </div>
                            </dx:PanelContent>
                        </PanelCollection>
                    </dx:ASPxCallbackPanel>

                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>



        <dx:ASPxPopupControl ID="popupLimitReached" runat="server"
            ClientInstanceName="popupLimitReached"
            PopupHorizontalAlign="WindowCenter"
            PopupVerticalAlign="WindowCenter"
            ShowCloseButton="true"
            CloseAction="OuterMouseClick"
            AllowDragging="True"
            Width="400px"
            Height="400px"
            HeaderText="تنبيه">

            <ContentCollection>
                <dx:PopupControlContentControl>
                    <div style="font-family: 'Cairo', sans-serif; font-size: 1.2em; text-align: center; padding: 2rem; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 2rem; height: 100%;">

                        <img src="assets/img/allowedImage.png" alt="تحذير"
                            style="width: 300px; max-width: 100%; height: auto;" />

                        <dx:ASPxLabel ID="popupMessage1" runat="server"
                            ClientInstanceName="popupMessage1"
                            Text="لقد وصلت إلى الحد الأقصى لعدد الصور المسموح به.<br/>(يمكنك تحميل 5 صور)"
                            Font-Names="Cairo"
                            Font-Size="22px" />
                    </div>
                </dx:PopupControlContentControl>
            </ContentCollection>
        </dx:ASPxPopupControl>

    </main>



</asp:Content>
