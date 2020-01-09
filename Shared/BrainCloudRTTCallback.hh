/**
 * This class handles RTT event callbacks and passes the data to Objective-C
 * via blocks.
 */

#pragma once

#import <Foundation/Foundation.h>
#import "BrainCloudCompletionBlocks.hh"
#import "braincloud/BrainCloudClient.h"
#import "braincloud/IRTTCallback.h"

class BrainCloudRTTCallback final : public BrainCloud::IRTTCallback
{
public:
    void setEventBlock(BCRTTEventBlock eventBlock, BCCallbackObject cbObject)
    {
        m_eventBlock = eventBlock;
        m_cbObject = cbObject;
    }

protected:
    void rttCallback(const Json::Value& eventJson) override
    {
        if (m_eventBlock)
        {
            Json::FastWriter fastWriter;
            std::string jsonString = fastWriter.write(eventJson);
            m_eventBlock([NSString stringWithUTF8String:jsonString.c_str()], m_cbObject);
        }
    }

private:
    BCRTTEventBlock m_eventBlock = nil;
    BCCallbackObject m_cbObject = nil;
};
