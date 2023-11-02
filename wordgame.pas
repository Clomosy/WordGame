var 
  MyForm:TCLForm;
  LblDisplay,ztStartLbl:TclLabel;
  myGameEngine:TclGameEngine;
  MyWord, WordMean:String;
  WordEdtPanel:TclPanel;
  WordMemo:TclMemo;
  kelimeEdt :TclEdit;
  wordEdtBtnLyt :TclProPanel;
  ztHintBtn :TclImage;
  ztLayout,ztStartBtnLayout,gameContentLyt,EdtBtnLyt:TclLayout;
  ztStartBtn,OkBtn:TclImage;
  AnswStr:String;
  wrongCount:integer;
  Lblword:TcLProLabel;
  control : Boolean;
  chance : Integer;
  
  
  Procedure GetNewWord;
  begin
    myGameEngine:= TclGameEngine.Create;
    MyWord := MyGameEngine.WordService('GETWORD:5','');
    With Clomosy.ClDataSetFromJSON(MyWord) Do 
    Begin
      MyWord := FieldByName('Word').AsString;
      MyWord := AnsiUpperCase(MyWord);
      LblDisplay.Text := MyWord;//UpperCase
      WordMean := FieldByName('MeanText').AsString; 
    End;
  End;
  
  Procedure CheckGameOnClick;
  begin
    AnswStr := kelimeEdt.Text;
    AnswStr := AnsiUpperCase(AnswStr);
    If AnswStr=MyWord Then
    begin
      ShowMessage('Tebrikler🤗');
      chance := 0;
      control := false;
      ztStartBtn.Visible:=True;
      OkBtn.Visible:=False;
      //ztStartLbl.Text := ' ';
      kelimeEdt.Text :='';
        LblDisplay.Visible := False;
        WordMemo.Text := '';
        WordMemo.Enabled:=False;
        kelimeEdt.Enabled:=False;
    end;
    else
    begin
      if wrongCount = 3 then
      begin
        ShowMessage('Kelime: '+MyWord+' Başarısız oldun yeniden başlatıldı.🙁');
        chance := 0;
        control := false;
        ztStartBtn.Visible:=True;
        OkBtn.Visible:=False;
        //ztStartLbl.Text := ' ';
        wrongCount := 1;
        GetNewWord;
       
        kelimeEdt.Text := '';
        WordMemo.Text := '';
        LblDisplay.Visible := False;
        WordMemo.Enabled:=False;
        kelimeEdt.Enabled:=False;
      end
      
      else  if kelimeEdt.Text = '' then
      begin
      ShowMessage('Lütfen Kutucuğu doldurunuz');
      end;
      
      else
      begin
        wrongCount := wrongCount +1;
        ShowMessage('Yanlış Tekrar Deneyin.🙁  Kalan Hakkın  '+IntToStr(wrongCount-1)+'/3');
        kelimeEdt.Text := '';
      end;
    end;
  end;
  
  Procedure BtnStartGameClick;
  begin
    WordMemo.Enabled:=True;
    kelimeEdt.Enabled:=True;
    ztStartBtn.Visible:=False;
    OkBtn.Visible:=True;
  
    wrongCount := 1;
    GetNewWord;
    WordMemo.Text := WordMean;
    kelimeEdt.Text :='';
    LblDisplay.Visible := False;
  End;

  Procedure SetupStartBtn;
  begin
    ztLayout := MyForm.AddNewLayout(MyForm,'ztLayout');
    ztLayout.Align:=alBottom;
    ztLayout.Height := 200;
    ztLayout.Width := 100;
    ztLayout.Margins.Bottom := 30;
    
    
    ztStartBtnLayout := MyForm.AddNewLayout(ztLayout,'ztStartBtnLayout');
    ztStartBtnLayout.Align:=alCenter;
    ztStartBtnLayout.Height := 100;
    ztStartBtnLayout.Width := 100;
    
    ztStartBtn:= MyForm.AddNewImage(ztStartBtnLayout,'ztStartBtn');
    ztStartBtn.Align := alTop;
    ztStartBtn.Height := 100;
    ztStartBtn.Width := 100;
    
    MyForm.setImage(ztStartBtn,'https://clomosy.com/educa/start.png');
    
    MyForm.AddNewEvent(ztStartBtn,tbeOnClick,'BtnStartGameClick');
    
    OkBtn := MyForm.AddNewProImage(EdtBtnLyt,'OkBtn');
    clComponent.SetupComponent(OkBtn,'{"Align" : "Left","Width":100,"Height":100,"ImgUrl":"https://clomosy.com/educa/ok.png", "ImgFit":"yes"}');
    OkBtn.Visible:=False;
    MyForm.AddNewEvent(OkBtn,tbeOnClick,'CheckGameOnClick');
    
  end;
  
  Procedure ztHintBtnOnClick;
  var
    hintValue : String;
    firstLetter,secondLetter : String;
    firstIndex,secondIndex : Integer;
    i : Integer;
    rasgeleSayi : Integer;
    
    begin
      if WordMemo.Text <> '' then
      begin
           if control = false then
      begin
       control := true;
       
             if chance < 2 then
            begin
              chance := chance +1;
              
              // RASTGELE 2 DEĞERİ ALIYOR
                for i := 1 to 5 do
                begin
                    firstIndex := clMath.GenerateRandom(1,5);
                    secondIndex := clMath.GenerateRandom(1,5);
                    if secondIndex <> firstIndex then
                      break;
                end;
                
                // HARFLER ALINDI
              firstLetter := Copy(MyWord,firstIndex,1); //L
              secondLetter := Copy(MyWord,secondIndex,1); //U
              LblDisplay.Visible := True;
              LblDisplay.Text := ''; //?
              
              // HARFLER LABELA YAZILDI
                  for i:= 1 to 5 do
                  begin
                      if i = firstIndex then
                        LblDisplay.Text := LblDisplay.Text + firstLetter
                      else if i = secondIndex then 
                        LblDisplay.Text := LblDisplay.Text + secondLetter
                        
                      else
                        LblDisplay.Text := LblDisplay.Text + ' - ';
                  end;
            end;
      end
      else
        ShowMessage('Başka Hakkınız Kalmadı 😞');
      
    
      end
      else
        ShowMessage('Oyunu Başlat! 😎');
      
  
    end;
    
  
  Procedure GetWordMemo;
  var
   ztProPanel : TclProPanel;
   begin
    ztProPanel:=MyForm.AddNewProPanel(gameContentLyt,'ztProPanel');
    clComponent.SetupComponent(ztProPanel,'{"Align" : "MostTop",
    "MarginLeft" : 10,"MarginRight" : 10,
    "Height":100,"RoundHeight":10,"RoundWidth":10,"BorderColor":"#9400D3","BorderWidth":3}');
    
    WordMemo:= MyForm.AddNewMemo(ztProPanel,'WordMemo','');
    WordMemo.Align := alClient;
    WordMemo.Margins.Left:=10;
    WordMemo.Margins.Right:=10;
    WordMemo.Margins.Bottom:=10;
    WordMemo.Margins.Top:=10;
    WordMemo.ReadOnly := True;
    WordMemo.TextSettings.WordWrap := True;
    WordMemo.Enabled:=False;
   end;
  
procedure getTitle;
begin
  Lblword := MyForm.AddNewProLabel(MyForm,'Lblword','KELİME OYUNU');
  clComponent.SetupComponent(Lblword,'{"Align" : "MostTop","MarginBottom":35,"Width" :210, "Height":26,"TextColor":"#F2F0F0","TextSize":20,"TextVerticalAlign":"top", "TextHorizontalAlign":"center","TextBold":"yes"}');
  
end;
procedure editBtnHintContent;
begin
  wordEdtBtnLyt:=MyForm.AddNewProPanel(gameContentLyt,'wordEdtBtnLyt');
  clComponent.SetupComponent(wordEdtBtnLyt,'{"Align" : "Top","Height":130,"MarginTop" : 10,"MarginRight" : 10,"MarginLeft" : 10,
  "RoundHeight":10,"RoundWidth":10,"BorderColor":"#9400D3","BorderWidth":3,"BackgroundColor":"#ffffff"}');
  
  //KELİME EDİT VE İPUCU BUTONU KISMI 
  
  EdtBtnLyt := MyForm.AddNewLayout(wordEdtBtnLyt,'EdtBtnLyt');
  EdtBtnLyt.Align := alTop;
  EdtBtnLyt.Margins.Top:= 10;
  EdtBtnLyt.Height := 100;
  
  

    WordEdtPanel:= MyForm.AddNewPanel(EdtBtnLyt,'WordEdtPanel','');
    WordEdtPanel.Align := alLeft;
    WordEdtPanel.Height := 10;
    WordEdtPanel.Width := 100;
    WordEdtPanel.Margins.Top:= 30;
    WordEdtPanel.Margins.Bottom:= 30;
    WordEdtPanel.Margins.Left:= 20;
   
    kelimeEdt := MyForm.AddNewEdit(WordEdtPanel,'kelimeEdt','_____________');
    kelimeEdt.Align := alClient;
    kelimeEdt.MaxLength := 5;
    kelimeEdt.Enabled:=False;
    
    ztHintBtn:= MyForm.AddNewImage(EdtBtnLyt,'ztHintBtn');
    ztHintBtn.Align := alRight;
    ztHintBtn.Height := 55;
    ztHintBtn.Width := 55;
    ztHintBtn.Margins.Right:=20;
    MyForm.setImage(ztHintBtn,'https://clomosy.com/educa/hint.png');
    MyForm.AddNewEvent(ztHintBtn,tbeOnClick,'ztHintBtnOnClick');
    
    //ipucu mesajı
    LblDisplay:= MyForm.AddNewLabel(wordEdtBtnLyt,'LblDisplay',' ');
    LblDisplay.Align := alRight;
    LblDisplay.Visible := True;
    EdtBtnLyt.Height := 80;
    LblDisplay.Margins.Right:= 20;
    LblDisplay.Margins.Bottom:= 10;
  
end;


procedure getGameContent
begin
  gameContentLyt := MyForm.AddNewLayout(MyForm,'gameContentLyt');
  gameContentLyt.Align := alTop;
  gameContentLyt.Margins.Left:= 10;
  gameContentLyt.Margins.Right:= 10;
  gameContentLyt.Height := 300;
  
  GetWordMemo;
  
  editBtnHintContent;
end;


begin
  ShowMessage('Kelime Oyununa hoşgeldin. Oyuna "START" butonuna basarak başlamalısın. Oyundaki bulacağın kelime 5 harfli. 3 hakkın bulunmakta. Haydi, oyuna başlamaya hazırsın.');
  MyForm := TCLForm.Create(Self);
  chance := 0;
  getTitle;
  getGameContent;
  MyForm.SetFormBGImage('https://clomosy.com/educa/bg4.png');
  control := false;
  
  SetupStartBtn;

  MyForm.Run;
End;