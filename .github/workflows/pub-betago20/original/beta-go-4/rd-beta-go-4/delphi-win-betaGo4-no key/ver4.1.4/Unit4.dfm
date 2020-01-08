object Form4: TForm4
  Left = 233
  Top = 114
  Width = 405
  Height = 370
  Caption = 'Evaluation Period Expired'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 24
    Top = 16
    Width = 305
    Height = 217
    Lines.Strings = (
      'We are sorry, but the evaluation period for software'
      'has expired. Please contact us in writing to order a'
      'permanent working version or a limited time working '
      'version. '
      ''
      'The limited time working version is available for 30 days'
      'at $500.00 via check or money order drawn on a U.S. bank.'
      'The permanent working version is available for $5000.00'
      'via check or money order drawn on a U.S. bank.'
      ''
      'Please feel free to contact us in writing at:'
      ''
      'Kanecki Associates'
      '4410 19th Avenue'
      'Kenosha, WI 53140')
    TabOrder = 0
  end
  object Button1: TButton
    Left = 136
    Top = 256
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
end
