HMMaterialButton
===========

Subclass of UIButton using the Google material design


## Usage

####Step 1 : Add the HMMaterialButton.swift file to your xCode project.

####Step 2 : Setup the HMMaterialButtonDelegate and implement the TouchUpInside method delegated :
```swift
class MyClass : UIViewController, HMMaterialButtonDelegate
{
    internal func materialButtonTouchUpInside(button: HMMaterialButton)
    {
      // Call when user touch up inside.
    }
}
```

####Step 3 : Create your materialButton :
```swift
var materialButton: HMMaterialButton!
...
override func viewDidLoad()
{
  self.materialButton = HMMaterialButton(frame: CGRectMake(10, 10, 120, 40))
  self.materialButton.backgroundColor = UIColor.blueColor()
  self.materialButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
  self.materialButton.setTitle("touch me", forState:UIControlState.Normal)
  self.view.addSubview(self.materialButton)
  
  self.materialButton.delegate = self
}
```

####Step 4 : Build, Run and Enjoy !
