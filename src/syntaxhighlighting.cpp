/* syntax highlighting UI dialog. designed by irulanCorrino with an aid from OpenHands AI assistant */
#include "syntaxhighlighting.h"
#include <QVBoxLayout>
#include <QRadioButton>
#include <QButtonGroup>
#include <QSlider>
#include <QSpinBox>
#include <QLabel>
#include <QTextEdit>

SyntaxHighlighting::SyntaxHighlighting(QWidget *parent)
    : QDialog(parent)
{
    setWindowTitle("Syntax Highlighting");
    setModal(false);

    QVBoxLayout *mainLayout = new QVBoxLayout;
    setLayout(mainLayout);

    formatGroup = new QButtonGroup(this);
    backgroundRadio = new QRadioButton("Background", this);
    foregroundRadio = new QRadioButton("Foreground", this);
    // Add more radio buttons for other QTextCharFormat options

    formatGroup->addButton(backgroundRadio);
    formatGroup->addButton(foregroundRadio);
    // Add more buttons to the group

    mainLayout->addWidget(backgroundRadio);
    mainLayout->addWidget(foregroundRadio);
    // Add more radio buttons to the layout

    redSlider = new QSlider(Qt::Horizontal, this);
    greenSlider = new QSlider(Qt::Horizontal, this);
    blueSlider = new QSlider(Qt::Horizontal, this);

    redSpin = new QSpinBox(this);
    greenSpin = new QSpinBox(this);
    blueSpin = new QSpinBox(this);

    // Set up sliders and spin boxes
    // Connect signals and slots for updating the format and preview

    QTextEdit *preview = new QTextEdit(this);
    preview->setReadOnly(true);
    preview->setText("Sample KTurtle code...");
    mainLayout->addWidget(preview);
}

void SyntaxHighlighting::updateFormat()
{
    // Logic to update QTextCharFormat based on selected options
}

void SyntaxHighlighting::updatePreview()
{
    // Logic to update the preview with the current format settings
}
