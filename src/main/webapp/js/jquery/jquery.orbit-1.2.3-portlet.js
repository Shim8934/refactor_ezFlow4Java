/*
 * jQuery Orbit Plugin 1.2.3
 * www.ZURB.com/playground
 * Copyright 2010, ZURB
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
*/


(function($) {

    $.fn.orbit2 = function(options2) {

        //Defaults to extend options
        var defaults = {  
            animation: 'horizontal-push', 		// fade, horizontal-slide, vertical-slide, horizontal-push
            animationSpeed: 600, 				// how fast animtions are
            timer: true, 						// true or false to have the timer
            advanceSpeed: 4000, 				// if timer is enabled, time between transitions 
            pauseOnHover: false, 				// if you hover pauses the slider
            startClockOnMouseOut: false, 		// if clock should start on MouseOut
            startClockOnMouseOutAfter: 1000, 	// how long after MouseOut should the timer start again
            directionalNav: true, 				// manual advancing directional navs
            captions: true, 					// do you want captions?
            captionAnimation: 'fade', 			// fade, slideOpen, none
            captionAnimationSpeed: 600, 		// if so how quickly should they animate in
            bullets: false,						// true or false to activate the bullet navigation
            bulletThumbs: false,				// thumbnails for the bullets
            bulletThumbLocation: '',			// location from this file where thumbs will be
            afterSlideChange: function(){} 		// empty function 
     	};  
        
        //Extend those options
        var options2 = $.extend(defaults, options2); 
	
        return this.each(function() {
        
// ==============
// ! SETUP   
// ==============
        
            //Global Variables
            var activeSlide2 = 0,
            	numberSlides2 = 0,
            	orbitWidth2,
            	orbitHeight2,
            	locked2;
            
            //Initialize
            var orbit2 = $(this).addClass('orbit2'),         
            	orbitWrapper2 = orbit2.wrap('<div class="orbit2-wrapper" />').parent();
            orbit2.add(orbitWidth2).width('1px').height('1px');
	    	            
            //Collect all slides and set slider size of largest image
            var slides = orbit2.children('img, a, div');
            slides.each(function() {
                var _slide = $(this),
                	_slideWidth = _slide.width(),
                	_slideHeight = _slide.height();
                if(_slideWidth > orbit2.width()) {
	                orbit2.add(orbitWrapper2).width(_slideWidth);
	                orbitWidth2 = orbit2.width();	       			
	            }
	            if(_slideHeight > orbit2.height()) {
	                orbit2.add(orbitWrapper2).height(_slideHeight);
	                orbitHeight2 = orbit2.height();
				}
                numberSlides2++;
            });
            
            //Animation locking functions
            function unlock() {
                locked2 = false;
            }
            function lock() { 
                locked2 = true;
            }
            
            //If there is only a single slide remove nav, timer and bullets
            if(slides.length == 1) {
            	options2.directionalNav = false;
            	options2.timer = false;
            	options2.bullets = false;
            }
            
            //Set initial front photo z-index and fades it in
            slides.eq(activeSlide2)
            	.css({"z-index" : 3})
            	.fadeIn(function() {
            		//brings in all other slides IF css declares a display: none
            		slides.css({"display":"block"})
            	});
            
// ==============
// ! TIMER   
// ==============

            //Timer Execution
            function startClock2() {
            	if(!options2.timer  || options2.timer == 'false') { 
            		return false;
            	//if timer is hidden, don't need to do crazy calculations
            	} else if(timer.is(':hidden')) {
		            clock2 = setInterval(function(e){
						shift2("next");  
		            }, options2.advanceSpeed);            		
		        //if timer is visible and working, let's do some math
            	} else {
		            timerRunning = true;
		            pause2.removeClass('active2')
		            clock2 = setInterval(function(e){
		                var degreeCSS = "rotate("+degrees2+"deg)"
		                degrees2 += 2
		                rotator2.css({ 
		                    "-webkit-transform": degreeCSS,
		                    "-moz-transform": degreeCSS,
		                    "-o-transform": degreeCSS
		                });
		                if(degrees2 > 180) {
		                    rotator2.addClass('move2');
		                    mask2.addClass('move2');
		                }
		                if(degrees2 > 360) {
		                    rotator2.removeClass('move2');
		                    mask2.removeClass('move2');
		                    degrees2 = 0;
		                    shift2("next");
		                }
		            }, options2.advanceSpeed/180);
				}
	        }
	        function stopClock2() {
	        	if(!options2.timer || options2.timer == 'false') { return false; } else {
		            timerRunning = false;
		            clearInterval(clock2);
		            pause2.addClass('active2');
				}
	        }  
            
            //Timer Setup
            if(options2.timer) {         	
                var timerHTML = '<div class="timer2"><span class="mask2"><span class="rotator2"></span></span><span class="pause2"></span></div>'
                orbitWrapper2.append(timerHTML);
                var timer2 = orbitWrapper2.children('div.timer2'),
                	timerRunning;
                if(timer2.length != 0) {
                    var rotator2 = $('div.timer2 span.rotator2'),
                    	mask2 = $('div.timer2 span.mask2'),
                    	pause2 = $('div.timer2 span.pause2'),
                    	degrees2 = 0,
                    	clock2; 
                    startClock2();
                    timer2.click(function() {
                        if(!timerRunning) {
                            startClock2();
                        } else { 
                            stopClock2();
                        }
                    });
                    if(options2.startClockOnMouseOut){
                        var outTimer2;
                        orbitWrapper2.mouseleave(function() {
                            outTimer2 = setTimeout(function() {
                                if(!timerRunning){
                                    startClock2();
                                }
                            }, options2.startClockOnMouseOutAfter)
                        })
                        orbitWrapper2.mouseenter(function() {
                            clearTimeout(outTimer2);
                        })
                    }
                }
            }  
	        
	        //Pause Timer on hover
	        if(options2.pauseOnHover) {
		        orbitWrapper2.mouseenter(function() {
		        	stopClock2(); 
		        });
		   	}
            
// ==============
// ! CAPTIONS   
// ==============
                     
            //Caption Setup
            if(options2.captions) {
                var captionHTML = '<div class="orbit2-caption"></div>';
                orbitWrapper2.append(captionHTML);
                var caption = orbitWrapper2.children('.orbit2-caption');
            	setCaption();
            }
			
			//Caption Execution
            function setCaption() {
            	if(!options2.captions || options2.captions =="false") {
            		return false; 
            	} else {
	            	var _captionLocation = slides.eq(activeSlide2).data('caption'); //get ID from rel tag on image
	            		_captionHTML = $(_captionLocation).html(); //get HTML from the matching HTML entity            		
	            	//Set HTML for the caption if it exists
	            	if(_captionHTML) {
	            		caption
		            		.attr('id',_captionLocation) // Add ID caption
		                	.html(_captionHTML); // Change HTML in Caption 
		                //Animations for Caption entrances
		             	if(options2.captionAnimation == 'none') {
		             		caption.show();
		             	}
		             	if(options2.captionAnimation == 'fade') {
		             		caption.fadeIn(options2.captionAnimationSpeed);
		             	}
		             	if(options2.captionAnimation == 'slideOpen') {
		             		caption.slideDown(options2.captionAnimationSpeed);
		             	}
	            	} else {
	            		//Animations for Caption exits
	            		if(options2.captionAnimation == 'none') {
		             		caption.hide();
		             	}
		             	if(options2.captionAnimation == 'fade') {
		             		caption.fadeOut(options2.captionAnimationSpeed);
		             	}
		             	if(options2.captionAnimation == 'slideOpen') {
		             		caption.slideUp(options2.captionAnimationSpeed);
		             	}
	            	}
				}
            }
            
// ==================
// ! DIRECTIONAL NAV   
// ==================

            //DirectionalNav { rightButton --> shift("next"), leftButton --> shift("prev");
            if(options2.directionalNav) {
            	if(options2.directionalNav == "false") { return false; }
                var directionalNavHTML = '<div class="slider-nav2"><span class="right">Right</span><span class="left">Left</span></div>';
                orbitWrapper2.append(directionalNavHTML);
                var leftBtn = orbitWrapper2.children('div.slider-nav2').children('span.left'),
                	rightBtn = orbitWrapper2.children('div.slider-nav2').children('span.right');
                leftBtn.click(function() { 
                    stopClock2();
                    shift2("prev");
                });
                rightBtn.click(function() {
                    stopClock2();
                    shift2("next")
                });
            }
            
// ==================
// ! BULLET NAV   
// ==================
            
            //Bullet Nav Setup
            if(options2.bullets) { 
            	var bulletHTML = '<ul class="orbit2-bullets"></ul>';            	
            	orbitWrapper2.append(bulletHTML);
            	var bullets = orbitWrapper2.children('ul.orbit2-bullets');
            	for(i=0; i<numberSlides2; i++) {
            		var liMarkup = $('<li>'+(i+1)+'</li>');
            		if(options2.bulletThumbs) {
            			var	thumbName = slides.eq(i).data('thumb');
            			if(thumbName) {
            				var liMarkup = $('<li class="has-thumb2">'+i+'</li>')
            				liMarkup.css({"background" : "url("+options2.bulletThumbLocation+thumbName+") no-repeat"});
            			}
            		} 
            		orbitWrapper2.children('ul.orbit2-bullets').append(liMarkup);
            		liMarkup.data('index',i);
            		liMarkup.click(function() {
            			stopClock2();
            			shift2($(this).data('index'));
            		});
            	}
            	setActiveBullet2();
            }
            
            //Bullet Nav Execution
        	function setActiveBullet2() { 
        		if(!options2.bullets) { return false; } else {
	        		bullets.children('li').removeClass('active2').eq(activeSlide2).addClass('active2');
	        	}
        	}
        	
// ====================
// ! SHIFT ANIMATIONS   
// ====================
            
            //Animating the shift!
            function shift2(direction) {
        	    //remember previous activeSlide2
                var prevactiveSlide2 = activeSlide2,
                	slideDirection = direction;
                //exit function if bullet clicked is same as the current image
                if(prevactiveSlide2 == slideDirection) { return false; }
                //reset Z & Unlock
                function resetAndUnlock() {
                    slides
                    	.eq(prevactiveSlide2)
                    	.css({"z-index" : 1});
                    unlock();
                    options2.afterSlideChange.call(this);
                }
                if(slides.length == "1") { return false; }
                if(!locked2) {
                    lock();
					 //deduce the proper activeImage
                    if(direction == "next") {
                        activeSlide2++
                        if(activeSlide2 == numberSlides2) {
                            activeSlide2 = 0;
                        }
                    } else if(direction == "prev") {
                        activeSlide2--
                        if(activeSlide2 < 0) {
                            activeSlide2 = numberSlides2-1;
                        }
                    } else {
                        activeSlide2 = direction;
                        if (prevactiveSlide2 < activeSlide2) { 
                            slideDirection = "next";
                        } else if (prevactiveSlide2 > activeSlide2) { 
                            slideDirection = "prev"
                        }
                    }
                    //set to correct bullet
                     setActiveBullet2();  
                     
                    //set previous slide z-index to one below what new activeSlide2 will be
                    slides
                    	.eq(prevactiveSlide2)
                    	.css({"z-index" : 2});    
                    
                    //fade
                    if(options2.animation == "fade") {
                        slides
                        	.eq(activeSlide2)
                        	.css({"opacity" : 0, "z-index" : 3})
                        	.animate({"opacity" : 1}, options2.animationSpeed, resetAndUnlock);
                    }
                    //horizontal-slide
                    if(options2.animation == "horizontal-slide") {
                        if(slideDirection == "next") {
                            slides
                            	.eq(activeSlide2)
                            	.css({"left": orbitWidth2, "z-index" : 3})
                            	.animate({"left" : 0}, options2.animationSpeed, resetAndUnlock);
                        }
                        if(slideDirection == "prev") {
                            slides
                            	.eq(activeSlide2)
                            	.css({"left": -orbitWidth2, "z-index" : 3})
                            	.animate({"left" : 0}, options2.animationSpeed, resetAndUnlock);
                        }
                    }
                    //vertical-slide
                    if(options2.animation == "vertical-slide") { 
                        if(slideDirection == "prev") {
                            slides
                            	.eq(activeSlide2)
                            	.css({"top": orbitHeight2, "z-index" : 3})
                            	.animate({"top" : 0}, options2.animationSpeed, resetAndUnlock);
                        }
                        if(slideDirection == "next") {
                            slides
                            	.eq(activeSlide2)
                            	.css({"top": -orbitHeight2, "z-index" : 3})
                            	.animate({"top" : 0}, options2.animationSpeed, resetAndUnlock);
                        }
                    }
                    //push-over
                    if(options2.animation == "horizontal-push") {
                        if(slideDirection == "next") {
                            slides
                            	.eq(activeSlide2)
                            	.css({"left": orbitWidth2, "z-index" : 3})
                            	.animate({"left" : 0}, options2.animationSpeed, resetAndUnlock);
                            slides
                            	.eq(prevactiveSlide2)
                            	.animate({"left" : -orbitWidth2}, options2.animationSpeed);
                        }
                        if(slideDirection == "prev") {
                            slides
                            	.eq(activeSlide2)
                            	.css({"left": -orbitWidth2, "z-index" : 3})
                            	.animate({"left" : 0}, options2.animationSpeed, resetAndUnlock);
							slides
                            	.eq(prevactiveSlide2)
                            	.animate({"left" : orbitWidth2}, options2.animationSpeed);
                        }
                    }
                    setCaption();
                } //lock
            }//orbit function
        });//each call
    }//orbit plugin call
})(jQuery);
