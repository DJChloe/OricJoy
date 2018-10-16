object f_main: Tf_main
  Left = 0
  Top = 0
  Caption = 'Oricutron Joystick'
  ClientHeight = 461
  ClientWidth = 544
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 560
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 352
    Width = 544
    Height = 109
    Align = alBottom
    Lines.Strings = (
      '')
    ReadOnly = True
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 544
    Height = 41
    Align = alTop
    TabOrder = 1
    object JoyState: TLabel
      Left = 241
      Top = 1
      Width = 142
      Height = 39
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Layout = tlCenter
      WordWrap = True
      ExplicitLeft = 347
      ExplicitWidth = 160
    end
    object Panel2: TPanel
      Left = 383
      Top = 1
      Width = 160
      Height = 39
      Align = alRight
      TabOrder = 0
      object Label1: TLabel
        Left = 1
        Top = 1
        Width = 56
        Height = 37
        Align = alLeft
        Alignment = taCenter
        AutoSize = False
        Caption = 'D-Pad'
        Layout = tlCenter
      end
      object Label2: TLabel
        Left = 99
        Top = 1
        Width = 60
        Height = 37
        Align = alRight
        Alignment = taCenter
        AutoSize = False
        Caption = 'Analog'
        Layout = tlCenter
        ExplicitLeft = 118
      end
      object EsSwitch1: TEsSwitch
        Left = 64
        Top = 9
        Width = 44
        Height = 20
        FrameColor = clRed
        ThumbColor = clBlack
        MainColor = clRed
        TabOrder = 0
      end
    end
    object GridPanel1: TGridPanel
      Left = 1
      Top = 1
      Width = 240
      Height = 39
      Align = alLeft
      BevelOuter = bvNone
      ColumnCollection = <
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end
        item
          SizeStyle = ssAbsolute
          Value = 30.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = jup
          Row = 0
        end
        item
          Column = 1
          Control = jleft
          Row = 0
        end
        item
          Column = 2
          Control = jb1
          Row = 0
        end
        item
          Column = 3
          Control = jb3
          Row = 0
        end
        item
          Column = 4
          Control = jb5
          Row = 0
        end
        item
          Column = 5
          Control = jb7
          Row = 0
        end
        item
          Column = 6
          Control = jb9
          Row = 0
        end
        item
          Column = 0
          Control = jdown
          Row = 1
        end
        item
          Column = 1
          Control = jright
          Row = 1
        end
        item
          Column = 2
          Control = jb2
          Row = 1
        end
        item
          Column = 3
          Control = jb4
          Row = 1
        end
        item
          Column = 7
          Control = jb11
          Row = 0
        end
        item
          Column = 4
          Control = jb6
          Row = 1
        end
        item
          Column = 5
          Control = jb8
          Row = 1
        end
        item
          Column = 6
          Control = jb10
          Row = 1
        end
        item
          Column = 7
          Control = jb12
          Row = 1
        end>
      ExpandStyle = emAddColumns
      RowCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      TabOrder = 1
      object jup: TStaticText
        Left = 0
        Top = 0
        Width = 30
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'up'
        Color = clWhite
        ParentColor = False
        TabOrder = 0
        Transparent = False
        StyleElements = [seBorder]
      end
      object jleft: TStaticText
        Left = 30
        Top = 0
        Width = 30
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'left'
        Color = clWhite
        ParentColor = False
        TabOrder = 1
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb1: TStaticText
        Left = 60
        Top = 0
        Width = 30
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b1'
        Color = clWhite
        ParentColor = False
        TabOrder = 2
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb3: TStaticText
        Left = 90
        Top = 0
        Width = 30
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b3'
        Color = clWhite
        ParentColor = False
        TabOrder = 3
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb5: TStaticText
        Left = 120
        Top = 0
        Width = 30
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b5'
        Color = clWhite
        ParentColor = False
        TabOrder = 4
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb7: TStaticText
        Left = 150
        Top = 0
        Width = 30
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b7'
        Color = clWhite
        ParentColor = False
        TabOrder = 5
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb9: TStaticText
        Left = 180
        Top = 0
        Width = 30
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b9'
        Color = clWhite
        ParentColor = False
        TabOrder = 6
        Transparent = False
        StyleElements = [seBorder]
      end
      object jdown: TStaticText
        Left = 0
        Top = 19
        Width = 30
        Height = 20
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'down'
        Color = clWhite
        ParentColor = False
        TabOrder = 7
        Transparent = False
        StyleElements = [seBorder]
      end
      object jright: TStaticText
        Left = 30
        Top = 19
        Width = 30
        Height = 20
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'right'
        Color = clWhite
        ParentColor = False
        TabOrder = 8
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb2: TStaticText
        Left = 60
        Top = 19
        Width = 30
        Height = 20
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b2'
        Color = clWhite
        ParentColor = False
        TabOrder = 9
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb4: TStaticText
        Left = 90
        Top = 19
        Width = 30
        Height = 20
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b4'
        Color = clWhite
        ParentColor = False
        TabOrder = 10
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb11: TStaticText
        Left = 210
        Top = 0
        Width = 30
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b11'
        Color = clWhite
        ParentColor = False
        TabOrder = 11
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb6: TStaticText
        Left = 120
        Top = 19
        Width = 30
        Height = 20
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b6'
        Color = clWhite
        ParentColor = False
        TabOrder = 12
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb8: TStaticText
        Left = 150
        Top = 19
        Width = 30
        Height = 20
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b8'
        Color = clWhite
        ParentColor = False
        TabOrder = 13
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb10: TStaticText
        Left = 180
        Top = 19
        Width = 30
        Height = 20
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b10'
        Color = clWhite
        ParentColor = False
        TabOrder = 14
        Transparent = False
        StyleElements = [seBorder]
      end
      object jb12: TStaticText
        Left = 210
        Top = 19
        Width = 30
        Height = 20
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSingle
        Caption = 'b12'
        Color = clWhite
        ParentColor = False
        TabOrder = 15
        Transparent = False
        StyleElements = [seBorder]
      end
    end
  end
  object ListView1: TListView
    Left = 0
    Top = 41
    Width = 544
    Height = 311
    Align = alClient
    Columns = <>
    IconOptions.AutoArrange = True
    TabOrder = 2
    OnDblClick = ListView1DblClick
    OnSelectItem = ListView1SelectItem
  end
  object ImageList1: TImageList
    Height = 240
    Width = 240
    Left = 552
    Top = 440
  end
  object JoyTimer: TTimer
    Interval = 20
    OnTimer = JoyTimerTimer
    Left = 512
    Top = 440
  end
end
