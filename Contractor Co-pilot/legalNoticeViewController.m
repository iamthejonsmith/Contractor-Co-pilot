//
//  legalNoticeViewController.m
//  Contractor Co-pilot
//
//  Created by Jon Smith on 8/24/15.
//  Copyright (c) 2015 Jon Smith. All rights reserved.
//

#import "legalNoticeViewController.h"
#import "AppDelegate.h"

@interface legalNoticeViewController ()

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation legalNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    CAGradientLayer *viewLayer = [_appDelegate makeBackgroundLayerForView:self.view];
    [self.view.layer insertSublayer:viewLayer atIndex:0];
    
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    self.navigationController.navigationBar.translucent = NO;
    
    _textView.text = @"Contractor Co-pilot Terms and Conditions of Use\n\n1. Terms\n\nBy using this application, you are agreeing to be bound by Terms and Conditions of Use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this application. The materials contained in this application are protected by applicable copyright and trade mark law.\n\n2. Use License\n\nPermission is granted to temporarily download one copy of the materials (information or software) on Nutech Systems, Inc.'s application for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not: modify or copy the materials, use the materials for any commercial purpose, or for any public display (commercial or non-commercial), attempt to decompile or reverse engineer any software contained on Nutech Systems, Inc.'s application, remove any copyright or other proprietary notations from the materials, or transfer the materials to another person or 'mirror' the materials on any other server. This license shall automatically terminate if you violate any of these restrictions and may be terminated by Nutech Systems, Inc. at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.\n\n3. Disclaimer\n\n The materials on Nutech Systems, Inc.'s application are provided 'as is'. Nutech Systems, Inc. makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, Nutech Systems, Inc. does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its location application or otherwise relating to such materials or on any sites linked to this application.\n\n4. Limitations\n\nIn no event shall Nutech Systems, Inc. or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption,) arising out of the use or inability to use the materials on Nutech Systems, Inc.'s application, even if Nutech Systems, Inc. or a Nutech Systems, Inc. authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.\n\n5. Revisions and Errata\n\nThe materials appearing on Nutech Systems, Inc.'s application could include technical, typographical, or photographic errors. Nutech Systems, Inc. does not warrant that any of the materials on its application are accurate, complete, or current. Nutech Systems, Inc. may make changes to the materials contained on its application at any time without notice. Nutech Systems, Inc. does not, however, make any commitment to update the materials.\n\n6. Links\n\nNutech Systems, Inc. has not reviewed all of the sites linked to its application and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Nutech Systems, Inc. of the site. Use of any such linked web site is at the user's own risk.\n\n7. Application Terms of Use Modifications\n\nNutech Systems, Inc. may revise these terms of use for its application at any time without notice. By using this application you are agreeing to be bound by the then current version of these Terms and Conditions of Use.\n\n8. Governing Law\n\nAny claim relating to Nutech Systems, Inc.'s application shall be governed by the laws of the State of Atlanta without regard to its conflict of law provisions.\n\nGeneral Terms and Conditions applicable to Use of a application.\n\nPrivacy Policy\n\nYour privacy is very important to us. Accordingly, we have developed this Policy in order for you to understand how we collect, use, communicate and disclose and make use of personal information. The following outlines our privacy policy.\n\nBefore or at the time of collecting personal information, we will identify the purposes for which information is being collected. We will collect and use of personal information solely with the objective of fulfilling those purposes specified by us and for other compatible purposes, unless we obtain the consent of the individual concerned or as required by law. We will only retain personal information as long as necessary for the fulfillment of those purposes. We will collect personal information by lawful and fair means and, where propriate, with the knowledge or consent of the individual concerned. Personal data should be relevant to the purposes for which it is to be used, and, to the extent necessary for those purposes, should be accurate, complete, and up-to-date. We will protect personal information by reasonable security safeguards against loss or theft, as well as unauthorized access, disclosure, copying, use or modification. We will make readily available to customers information about our policies and practices relating to the management of personal information. We are committed to conducting our business in accordance with these principles in order to ensure that the confidentiality of personal information is protected and maintained.\n\nYellow Pages\n\nThis Application is powered by the Yellow Pages API. By using the Contractor Co-pilot Application you agree to abide by all terms and conditions as outlined on the Yellow Pages Website";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
