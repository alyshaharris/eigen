#import "WatchArtwork+ArtsyModels.h"

#import "Artist.h"
#import "Artwork.h"

@implementation WatchArtwork (FromArtwork)

- (instancetype)initWithArtsyArtwork:(Artwork *)artwork
{
    return [[WatchArtwork alloc] initWithArtworkID:artwork.artworkID title:artwork.title date:artwork.date artistName:artwork.artist.name thumbnailImageURL:artwork.defaultImage.urlForSquareImage];
}

@end
