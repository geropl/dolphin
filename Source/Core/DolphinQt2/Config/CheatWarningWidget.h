// Copyright 2017 Dolphin Emulator Project
// Licensed under GPLv2+
// Refer to the license.txt file included.

#pragma once

#include <QWidget>

#include <string>

class QLabel;
class QPushButton;
class QTimer;

class CheatWarningWidget : public QWidget
{
  Q_OBJECT
public:
  explicit CheatWarningWidget(const std::string& game_id);

signals:
  void OpenCheatEnableSettings();
  void CheatEnableToggled();
  void EmulationStarted();
  void EmulationStopped();

private:
  const std::string& m_game_id;

  void CreateWidgets();
  void ConnectWidgets();

  void Update();

  QLabel* m_text;
  QPushButton* m_config_button;
};
