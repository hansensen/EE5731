int m_lambda = 200; 
% change this value to change the weight of the smoothness or prior term

SOURCE_COLOR = [ 0, 0, 255 ]; % blue = foreground
SINK_COLOR = [45, 210, 110 ]; % yellow = background


for( int y = 0; y < img->height-1; y++ ) {
    for( int x = 0; x < img->width-1; x++ ){

    CvScalar c = cvGet2D( img, y, x );
    node = y * img->width + x;

    % data term:
    graph->add_tweights(node,dist(SOURCE_COLOR,c),dist(SINK_COLOR,c));

    % prior term: start

    int nx = x + 1; % the right neighbor
    int next_node = y*img->width+nx;
    graph->add_edge(node, next_node, m_lambda, m_lambda );

    int ny = y + 1; % the below neighbor
    next_node = ny*img->width+x;
    graph->add_edge(node, next_node, m_lambda, m_lambda );

    % prior term: end

    }
}

graph->maxflow();