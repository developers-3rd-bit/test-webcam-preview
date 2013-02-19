package
{
   import com.halcyon.layout.common.HalcyonButton;
   import com.halcyon.layout.common.HalcyonCanvas;
   import com.halcyon.layout.common.HalcyonHGroup;
   import com.halcyon.layout.common.HalcyonLabel;
   import com.halcyon.layout.common.HalcyonSpacer;
   import com.halcyon.layout.common.HalcyonVGroup;
   import com.soma.ui.layouts.HBoxUI;
   
   import fl.controls.ComboBox;
   
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.StatusEvent;
   import flash.media.Camera;
   import flash.media.Video;
   
   public class WebcamPreviewGroup_VGROUP extends HalcyonCanvas
   {
      public static const CLOSE_BTN_CLICK:String = "closeBtnClick";
      
      private var _bg:McPanelBg;
      private var _title:HalcyonLabel;
      private var _closeBtn:HalcyonButton;
      private var _topDivLine:McDivider;
      private var _vGroup:HalcyonVGroup;
      private var _cameraLabel:HalcyonLabel;
      private var _cameraComboBox:ComboBox;
      private var _camera:Camera;
      private var _video:Video;
      private var _webcamContainer:HalcyonCanvas;
      private var _noWebcamImage:McWebcamIcon;
      private var _infoLabel:HalcyonLabel;
      private var _bottomDivLine:McDivider;
      private var _buttonsHGroup:HalcyonHGroup;
      private var _optionsBtn:HalcyonButton;
      private var _cancelBtn:HalcyonButton;
      private var _okBtn:HalcyonButton;
      
      public function WebcamPreviewGroup_VGROUP(reference:DisplayObjectContainer, width:Number=15, height:Number=15)
      {
         super(reference, width, height);
         
         _bg = new McPanelBg();
         this.prepareElementAndPosition(_bg, 0, 0, 0, 0);
         
         _title = new HalcyonLabel("WEBCAM PREVIEW", 20);
         this.prepareElementAndPosition(_title, 20, NaN, 20, NaN);
         
         _topDivLine = new McDivider();
         this.prepareElementAndPosition(_topDivLine, 50, NaN, 20, 20);
         
         _closeBtn = new HalcyonButton(McCloseButton);
         _closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick, false, 0, true);
         this.prepareElementAndPosition(_closeBtn.content, 33, NaN, NaN, 12);
         
         _vGroup = new HalcyonVGroup(this, width - 48, height - 80);
         _vGroup.verticalGap = 5;
         
         _cameraLabel = new HalcyonLabel("Choose your camera:", 12);
         _vGroup.addChild(_cameraLabel);
         
         _cameraComboBox = new ComboBox();
         _cameraComboBox.width = 300;
         _cameraComboBox.addEventListener(Event.CHANGE, onCameraChange, false, 0, true);
         _vGroup.addChild(_cameraComboBox);
         
         var spacer1:HalcyonSpacer = new HalcyonSpacer(0, 5);
         _vGroup.addChild(spacer1);
         
         _webcamContainer = new HalcyonCanvas(_vGroup, 256, 256);
         _vGroup.addChild(_webcamContainer);
         
         _infoLabel = new HalcyonLabel("Click OK to iMeet in video.", 12);
         
         if (Camera.names.length > 0) 
         { 
            var selectObject:Object = new Object();
            selectObject.label = "Select";
            _cameraComboBox.dataProvider.addItem(selectObject);
            for(var i:int=0;i<Camera.names.length;i++) 
            {
               var item:Object = new Object();
               item.label = Camera.names[i];
               _cameraComboBox.dataProvider.addItem(item);
            }
         } 
         else 
         { 
            _infoLabel.label = "No webcam found.";
         }
         
         _noWebcamImage = new McWebcamIcon();
         _webcamContainer.prepareElementAndPosition(_noWebcamImage, NaN, NaN, 0, NaN);
         
         _vGroup.addChild(_infoLabel);
         
         var spacer2:HalcyonSpacer = new HalcyonSpacer(0, 20);
         _vGroup.addChild(spacer2);
         
         _bottomDivLine = new McDivider();
         _bottomDivLine.width = this.width - 40;
         _vGroup.addChild(_bottomDivLine);
         
         _buttonsHGroup = new HalcyonHGroup(_vGroup, _vGroup.width + 8, 40);
         _buttonsHGroup.childrenAlign = HBoxUI.ALIGN_TOP_RIGHT;
         _buttonsHGroup.horizontalgap = 8;
         
         _okBtn = new HalcyonButton(null, "OK");
         _okBtn.addEventListener(MouseEvent.CLICK, onOkBtnClick, false, 0, true);
         _buttonsHGroup.addChild(_okBtn.content);
         
         _cancelBtn = new HalcyonButton(null, "CANCEL");
         _cancelBtn.addEventListener(MouseEvent.CLICK, onCancelBtnClick, false, 0, true);
         _buttonsHGroup.addChild(_cancelBtn.content);
         
         _optionsBtn = new HalcyonButton(null, "OPTIONS");
         _optionsBtn.addEventListener(MouseEvent.CLICK, onOptionsBtnClick, false, 0, true);
         _buttonsHGroup.addChild(_optionsBtn.content);
         
         _vGroup.addChild(_buttonsHGroup);
         
         this.prepareElementAndPosition(_vGroup, 80, 20, 20, 20);
      }
      
      private function onCameraChange(event:Event):void
      {
         if(_cameraComboBox.selectedLabel == "Select") 
         {
            showNoWebcamImage();
            return;
         }
         startWebCam(_cameraComboBox.selectedLabel);
      }
      
      private function startWebCam(value:String):void 
      {
         _camera = Camera.getCamera();
         if (_camera != null) 
         { 
            _camera.addEventListener(StatusEvent.STATUS, onUserPermission, false, 0, true);
            _video = new Video(); 
            _video.attachCamera(_camera); 
            if(_webcamContainer.numChildren > 0)
               _webcamContainer.removeChild(_webcamContainer.getChildAt(0));
            _webcamContainer.width = 320;
            _webcamContainer.height = 240;
            _webcamContainer.prepareElementAndPosition(_video, 0, 0, 0, 0);
         }
      }
      
      private function onUserPermission(event:StatusEvent):void 
      { 
         switch (event.code) 
         { 
            case "Camera.Muted": 
               showNoWebcamImage();
               break; 
            case "Camera.Unmuted":
               trace("User allowed");
               break
         } 
      }
      
      private function showNoWebcamImage():void 
      {
         if(_webcamContainer.numChildren > 0)
            _webcamContainer.removeChild(_webcamContainer.getChildAt(0));
         _webcamContainer.width = 256;
         _webcamContainer.height = 256;
         _webcamContainer.prepareElementAndPosition(_noWebcamImage, NaN, NaN, 0, NaN);
      }
      
      private function onOkBtnClick(event:Event):void 
      {
         
      }
      
      private function onCancelBtnClick(event:Event):void 
      {
         
      }
      
      private function onOptionsBtnClick(event:Event):void 
      {
         
      }
      
      private function onCloseBtnClick(event:Event):void 
      {
         dispatchEvent(new Event(CLOSE_BTN_CLICK));  
      }
   }
}