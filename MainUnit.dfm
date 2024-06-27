object MainForm: TMainForm
  Left = 101
  Top = 116
  Width = 748
  Height = 470
  Caption = 'WaterFight'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Player1Control_DrawGrid: TDrawGrid
    Left = 32
    Top = 64
    Width = 281
    Height = 281
    Cursor = crHandPoint
    Color = clSkyBlue
    ColCount = 16
    DefaultColWidth = 16
    DefaultRowHeight = 16
    DefaultDrawing = False
    FixedColor = clCream
    FixedCols = 0
    RowCount = 16
    FixedRows = 0
    TabOrder = 0
    OnDrawCell = Player1Control_DrawGridDrawCell
    OnSelectCell = Player1Control_DrawGridSelectCell
  end
  object Player2Control_DrawGrid: TDrawGrid
    Left = 352
    Top = 64
    Width = 281
    Height = 281
    Cursor = crHandPoint
    Color = clSkyBlue
    ColCount = 16
    DefaultColWidth = 16
    DefaultRowHeight = 16
    DefaultDrawing = False
    FixedColor = clCream
    FixedCols = 0
    RowCount = 16
    FixedRows = 0
    TabOrder = 1
    OnDrawCell = Player2Control_DrawGridDrawCell
    OnSelectCell = Player2Control_DrawGridSelectCell
  end
  object Start_bn: TButton
    Left = 136
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = Start_bnClick
  end
  object Exit_bn: TButton
    Left = 456
    Top = 400
    Width = 75
    Height = 25
    Caption = 'Exit'
    TabOrder = 3
    OnClick = Exit_bnClick
  end
  object RichEdit1: TRichEdit
    Left = 32
    Top = 352
    Width = 281
    Height = 41
    BevelInner = bvNone
    BevelOuter = bvNone
    BevelKind = bkFlat
    Color = clBtnFace
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object RichEdit2: TRichEdit
    Left = 352
    Top = 352
    Width = 281
    Height = 41
    BevelInner = bvNone
    BevelOuter = bvNone
    BevelKind = bkFlat
    Color = clBtnFace
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object RB1: TRadioButton
    Left = 16
    Top = 16
    Width = 113
    Height = 17
    Caption = #20154#65293#20154
    TabOrder = 6
    OnClick = RB1Click
  end
  object RB2: TRadioButton
    Left = 144
    Top = 16
    Width = 129
    Height = 17
    Caption = #20154#65293#26426
    Checked = True
    TabOrder = 7
    TabStop = True
    OnClick = RB2Click
  end
  object RB3: TRadioButton
    Left = 280
    Top = 16
    Width = 145
    Height = 17
    Caption = #26426#65293#26426
    TabOrder = 8
    OnClick = RB3Click
  end
  object RB5: TRadioButton
    Left = 576
    Top = 16
    Width = 161
    Height = 17
    Caption = #32593#32476#65288#26410#23436#25104#65289
    TabOrder = 9
    OnClick = RB5Click
  end
  object rb4: TRadioButton
    Left = 432
    Top = 16
    Width = 129
    Height = 17
    Caption = #26426#65293#20154
    TabOrder = 10
    OnClick = rb4Click
  end
  object PCvsPCTimer: TTimer
    Enabled = False
    Interval = 300
    OnTimer = PCvsPCTimerTimer
    Left = 320
    Top = 168
  end
end
