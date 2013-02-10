//
//  UICamera.h
//  StudentConnect
//
//  Created by Michael Montaque on 5/25/12.
//  Copyright (c) 2012 Florida International University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SCOperationDelegate.h"
#import "MBProgressHUD.h"
#import "UIImage+ImageVerification.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

//Block Method declaration
typedef void (^TakePicture)(id img);

//---DEPRECATED---//
@protocol UICameraDelegate <NSObject>
-(void)cameraCancelledOperation;
@end

@interface UICamera : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate>{
   //Allows for multithreading
    dispatch_queue_t multiThread;
    
    __block UIPopoverController *pop;
    // Used as a point of ref is popover is set
    CGRect button;
    // The view the camera will appear in
    UIViewController* view;
    TakePicture camera;
    
}

@property(readonly)NSString* CAMERA;
@property(assign,nonatomic)BOOL usePopover;

// --- IN TESTING DO NOT USE --- //
@property(strong , nonatomic) ALAssetsLibrary* library;

// --- DEPRECATED --- //
@property(weak,nonatomic)id<UICameraDelegate> delegate;

// Use one of these init methods to setup the camera properly
// this will not show the camera on the screen, only instatiate the object
-(id)initInView:(id)newView;
-(id)initWithPopover:(BOOL)shouldPop button:(CGRect)rect popoverController:(UIPopoverController*)popover inView:(UIViewController*)newView;

// Call any of these methods to do as their name implies
// These methods will show the camera or photo album on the screen
// Their block parameter returns the pictures as a UIImage and video as NSdata
-(void)takeAPicture:(TakePicture)picture;
-(void)takeAVideo:(TakePicture)data;
-(void)takePictureFromAlbum:(TakePicture)picture;

//Do not use
//+(PicturesData*)savePictures:(NSManagedObjectContext*)context picture:(UIImage*)picture;
@end
