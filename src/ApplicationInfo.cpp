#include "ApplicationInfo.h"

ApplicationInfo::ApplicationInfo(const QtAM::Application* application, QObject *parent)
    : QObject(parent), m_application(application)
{
}

void ApplicationInfo::start()
{
    emit startRequested();
}

void ApplicationInfo::setAsWidget(bool value)
{
    if (value != m_asWidget) {
        m_asWidget = value;
        emit asWidgetChanged();
    }
}

bool ApplicationInfo::asWidget() const
{
    return m_asWidget;
}

void ApplicationInfo::setWindow(QQuickItem * window)
{
    if (window != m_window) {
        m_window = window;
        emit windowChanged();
    }
}

QQuickItem *ApplicationInfo::window() const
{
    return m_window;
}

const QtAM::Application *ApplicationInfo::application() const
{
    return m_application;
}

int ApplicationInfo::heightRows() const
{
    return m_heightRows;
}

void ApplicationInfo::setHeightRows(int value)
{
    if (value != m_heightRows) {
        m_heightRows = value;
        emit heightRowsChanged();
    }
}

bool ApplicationInfo::active() const
{
    return m_active;
}

void ApplicationInfo::setActive(bool value)
{
    if (m_active != value) {
        m_active = value;
        emit activeChanged();
    }
}

bool ApplicationInfo::canBeActive() const
{
    return m_canBeActive;
}

void ApplicationInfo::setCanBeActive(bool value)
{
    if (value != m_canBeActive) {
        m_canBeActive = value;
        emit canBeActiveChanged();
    }
}
