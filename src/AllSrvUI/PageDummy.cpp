/////////////////////////////////////////////////////////////////////////////
// PageDummy.cpp : implementation file
//

#include "stdafx.h"
#include "AllSrvUI.h"
#include "AllSrvUISheet.h"
#include "PageDummy.h"

#ifdef _DEBUG
  #define new DEBUG_NEW
  #undef THIS_FILE
  static char THIS_FILE[] = __FILE__;
#endif


/////////////////////////////////////////////////////////////////////////////
// CPageDummy property page

IMPLEMENT_DYNAMIC(CPageDummy, CPropertyPage)


/////////////////////////////////////////////////////////////////////////////
// Message Map

BEGIN_MESSAGE_MAP(CPageDummy, CPropertyPage)
  //{{AFX_MSG_MAP(CPageDummy)
  //}}AFX_MSG_MAP
END_MESSAGE_MAP()


/////////////////////////////////////////////////////////////////////////////
// Construction

CPageDummy::CPageDummy() :
  CPropertyPage(CPageDummy::IDD)
{
  //{{AFX_DATA_INIT(CPageDummy)
  //}}AFX_DATA_INIT
}


/////////////////////////////////////////////////////////////////////////////
// Attributes


/////////////////////////////////////////////////////////////////////////////
// Overrides

void CPageDummy::DoDataExchange(CDataExchange* pDX)
{
  // Perform default processing
  CPropertyPage::DoDataExchange(pDX);

  //{{AFX_DATA_MAP(CPageDummy)
  //}}AFX_DATA_MAP
}


/////////////////////////////////////////////////////////////////////////////
// Message Handlers

