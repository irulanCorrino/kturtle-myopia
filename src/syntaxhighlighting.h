/* syntax highlighting UI dialog. designed by irulanCorrino with an aid from OpenHands AI assistant */
#ifndef _SYNTAXHIGHLIGHTING_H_
#define _SYNTAXHIGHLIGHTING_H_

#include <QDialog>
#include <QTextCharFormat>

class QRadioButton;
class QSlider;
class QSpinBox;
class QButtonGroup;

class SyntaxHighlighting : public QDialog
{
    Q_OBJECT

public:
    explicit SyntaxHighlighting(QWidget *parent = nullptr);

private Q_SLOTS:
    void updateFormat();
    void updatePreview();

private:
    QButtonGroup *formatGroup;
    QRadioButton *backgroundRadio;
    QRadioButton *foregroundRadio;
    // Add more radio buttons for other QTextCharFormat options

    QSlider *redSlider;
    QSlider *greenSlider;
    QSlider *blueSlider;

    QSpinBox *redSpin;
    QSpinBox *greenSpin;
    QSpinBox *blueSpin;

    // Add a preview widget for displaying sample KTurtle code
};

#endif // _SYNTAXHIGHLIGHTING_H_
